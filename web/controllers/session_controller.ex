defmodule Workshop.SessionController do
  use Workshop.Web, :controller

  alias Workshop.User

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password }}) do
    user = Repo.get_by(User, email: email)

    if user && Comeonin.Bcrypt.checkpw(password, user.hashed_password) do
      conn
      |> put_flash(:info, "logged in")
      |> put_session(:current_user_id, user.id)
      |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "incorrect email or password")
      |> render("new.html")
    end
  end
  
  def delete(conn, _) do
    user = conn.assigns.current_user
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

end
