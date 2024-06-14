defmodule Amalgama.Accounts.Aggregates.UserTest do
  use Amalgama.AggregateCase, aggregate: Amalgama.Accounts.Aggregates.User

  alias Amalgama.Accounts.Events.UserRegistered

  describe "register user" do
    @tag :unit
    test "should succeed when valid" do
      user_uuid = UUID.uuid4()

      register_user_cmd = build(:register_user_cmd, user_uuid: user_uuid)

      assert_events(register_user_cmd, [
        %UserRegistered{
          user_uuid: user_uuid,
          email: "jake@jake.jake",
          username: "jake",
          hashed_password: "jakejake"
        }
      ])
    end
  end
end
