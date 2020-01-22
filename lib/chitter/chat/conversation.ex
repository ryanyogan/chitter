defmodule Chitter.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Chitter.Chat.{ConversationMember, Message}

  schema "chat_conversations" do
    field :title, :string

    has_many :conversation_members, ConversationMember, on_replace: :delete
    has_many :messages, Message
    has_many :users, through: [:conversation_members, :user]

    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title])
    |> cast_assoc(:conversation_members)
    |> validate_required([:title])
  end
end
