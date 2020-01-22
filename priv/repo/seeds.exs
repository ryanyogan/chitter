alias Chitter.Auth.User
alias Chitter.Chat.{Conversation, ConversationMember}

alias Chitter.{Auth, Chat}

rand1 = Enum.random(0..1000)
rand2 = Enum.random(0..1000)

{:ok, %User{id: u1_id} = user1} =
  Auth.create_user(%{
    email: "user_#{rand1}@yogan.dev",
    password: "p@55w0rd",
    confirm_password: "p@55w0rd",
    nickname: "User #{rand1}"
  })

{:ok, %User{id: u2_id} = user2} =
  Auth.create_user(%{
    email: "user_#{rand2}@yogan.dev",
    password: "p@55w0rd",
    confirm_password: "p@55w0rd",
    nickname: "User #{rand2}"
  })

{:ok, %Conversation{id: conv_id} = conversation} =
  Chat.create_conversation(%{
    title: "Modern Talking",
    conversation_members: [%{user_id: u1_id, owner: true}, %{user_id: u2_id, owner: false}]
  })

IO.puts("Created records:")
IO.inspect(user1)
IO.inspect(user2)
IO.inspect(conversation)
