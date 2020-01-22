defmodule ChitterWeb.DashboardLive do
  require Logger

  use Phoenix.LiveView, container: {:div, [class: "row"]}
  use Phoenix.HTML

  alias Chitter.{Auth, Chat}
  alias Chitter.Chat.Conversation
  alias ChitterWeb.DashboardView
  alias Chitter.Repo
  alias Ecto.Changeset

  def render(assigns) do
    DashboardView.render("show.html", assigns)
  end

  @spec mount(map, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(%{current_user: current_user}, socket) do
    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign_new_conversation_changeset()
     |> assign_contacts(current_user)}
  end

  # Create a conversation based on the payload that comes from the form (matched as `conversation_form`).
  # If its title is blank, build a title based on the nicknames of conversation members.
  # Finally, reload the current user's `conversations` association, and re-assign it to the socket,
  # so the template will be re-rendered.
  def handle_event(
        "create_conversation",
        %{"conversation" => conversation_form},
        %{
          assigns: %{
            conversation_changeset: changeset,
            current_user: current_user,
            contacts: contacts
          }
        } = socket
      ) do
    conversation_form =
      Map.put(
        conversation_form,
        "title",
        if(conversation_form["title"] == "",
          do: build_title(changeset, contacts),
          else: conversation_form["title"]
        )
      )

    case Chat.create_conversation(conversation_form) do
      {:ok, _} ->
        {:noreply,
         assign(
           socket,
           :current_user,
           Repo.preload(current_user, :conversations, force: true)
         )}

      {:error, err} ->
        Logger.error(inspect(err))
    end
  end

  # Add a new member to the newly created conversation.
  # "user-id" is passed from the link's "phx_value_user_id" attribute.
  # Finally, assign the changeset containing the new member's definition to the socket,
  # so the template can be re-rendered.
  def handle_event(
        "add_member",
        %{"user-id" => new_member_id},
        %{assigns: %{conversation_changeset: changeset}} = socket
      ) do
    {:ok, new_member_id} = Ecto.Type.cast(:integer, new_member_id)

    old_members = socket.assigns[:conversation_changeset].changes.conversation_members
    existing_ids = old_members |> Enum.map(& &1.changes.user_id)

    if new_member_id not in existing_ids do
      new_members = [%{user_id: new_member_id} | old_members]

      new_changeset = Changeset.put_change(changeset, :conversation_members, new_members)

      {:noreply, assign(socket, :conversation_changeset, new_changeset)}
    else
      {:noreply, socket}
    end
  end

  # Remove a member from the newly create conversation and handle it similarly to
  # when a member is added.
  def handle_event(
        "remove_member",
        %{"user-id" => removed_member_id},
        %{assigns: %{conversation_changeset: changeset}} = socket
      ) do
    {:ok, removed_member_id} = Ecto.Type.cast(:integer, removed_member_id)

    old_members = socket.assigns[:conversation_changeset].changes.conversation_members
    new_members = old_members |> Enum.reject(&(&1.changes[:user_id] == removed_member_id))

    new_changeset = Changeset.put_change(changeset, :conversation_members, new_members)

    {:noreply, assign(socket, :conversation_changeset, new_changeset)}
  end

  defp build_title(changeset, contacts) do
    user_ids = Enum.map(changeset.changes.conversation_members, & &1.changes.user_id)

    contacts
    |> Enum.filter(&(&1.id in user_ids))
    |> Enum.map(& &1.nickname)
    |> Enum.join(", ")
  end

  # Build a changeset for the newly created conversation, initially nesting a single conversation
  # member record - the current user - as the conversation's owner.
  #
  # We'll use the changeset to drive a form to be displayed in the rendered template.
  defp assign_new_conversation_changeset(socket) do
    changeset =
      %Conversation{}
      |> Conversation.changeset(%{
        "conversation_members" => [%{owner: true, user_id: socket.assigns[:current_user].id}]
      })

    assign(socket, :conversation_changeset, changeset)
  end

  # Assign all users as the contact list.
  defp assign_contacts(socket, _current_user) do
    users = Auth.list_auth_users()

    assign(socket, :contacts, users)
  end
end
