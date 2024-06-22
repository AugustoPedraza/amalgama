defmodule Amalgama.Blog.AuthorTest do
  use Amalgama.DataCase

  import Commanded.Assertions.EventAssertions
  import Amalgama.Factory

  alias Amalgama.CommandedApp
  alias Amalgama.Accounts
  alias Amalgama.Accounts.Projections.User
  alias Amalgama.Blog.Events.AuthorCreated

  describe "an author" do
    defp register_user(attrs \\ %{}) do
      Accounts.register_user(build(:user, attrs))
    end

    @tag :integration
    test "should be created when user registered" do
      assert {:ok, %User{} = user} = register_user()

      assert_receive_event(CommandedApp, AuthorCreated, fn event ->
        assert event.user_uuid == user.uuid
        assert event.username == user.username
      end)
    end
  end
end
