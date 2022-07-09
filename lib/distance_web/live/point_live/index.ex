defmodule DistanceWeb.PointLive.Index do
  use DistanceWeb, :live_view
  @keys ["q","w", "e", "a", "s", "d", " "]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, top: 0, bottom: 0, right: 0, left: 0, velocidad: 0, start: false, lista_velocidades: [])}
  end

  @impl true
  def handle_event("move", %{"key" => event}, socket) do

    eventKey = Enum.find_index(@keys, fn x ->
      x == event
    end)
    if is_nil(eventKey) do
      {:noreply,
        socket
        |> put_flash(:error, "Destruiste todo.")
        |> push_redirect(to: "/points")}
    else
      case socket.assigns.start do
        true ->
          do_something(socket, event)
        false ->
          if event == " "  do
            new_velocidad = List.insert_at(socket.assigns.lista_velocidades, 0, %{velocidad: 1, tiempo: 0, ini: DateTime.utc_now(), fin: ""})
            {:noreply, assign(socket, start: not socket.assigns.start, velocidad: 1, lista_velocidades: new_velocidad)}
          else
            {:noreply,
            socket
            |> put_flash(:info, "Debe presionar la tecla de espacio para iniciar.")
            |> push_redirect(to: "/points")}
          end
      end
    end
  end

  defp do_something(socket, event) when event == " " do
    if socket.assigns.start do
      first_element = List.first(socket.assigns.lista_velocidades)
      newList = List.replace_at(socket.assigns.lista_velocidades, 0, %{velocidad: socket.assigns.velocidad, tiempo: DateTime.diff(DateTime.utc_now(), first_element.ini), ini: first_element.ini, fin: DateTime.utc_now()})
      {:noreply, assign(socket, start: not socket.assigns.start, lista_velocidades: newList)}
    else
      {:noreply, assign(socket, start: not socket.assigns.start)}
    end
  end

  defp do_something(socket, event) when event == "q" do
    velocidad = socket.assigns.velocidad + 1
    IO.inspect velocidad
    if velocidad > 3 do
      {:noreply,
        socket
        |> put_flash(:info, "Velocidad Máxima 3.")}
    else
      first_element = List.first(socket.assigns.lista_velocidades)
      new_velocidad = if first_element.fin == "" do
        newList = List.replace_at(socket.assigns.lista_velocidades, 0, %{velocidad: socket.assigns.velocidad, tiempo: DateTime.diff(DateTime.utc_now(), first_element.ini), ini: first_element.ini, fin: DateTime.utc_now()})
        List.insert_at(newList, 0, %{velocidad: socket.assigns.velocidad + 1, tiempo: 0, ini: DateTime.utc_now(), fin: ""})
      else
        List.insert_at(socket.assigns.lista_velocidades, 0, %{velocidad: socket.assigns.velocidad, tiempo: 0, ini: first_element.ini, fin: ""})
      end
      {:noreply, assign(socket, velocidad: velocidad, lista_velocidades: new_velocidad)}
    end
  end

  defp do_something(socket, event) when event == "e" do
    velocidad = socket.assigns.velocidad - 1
    if velocidad <= 0 do
      {:noreply,
        socket
        |> put_flash(:info, "Velocidad Mínima 1.")}
    else
      first_element = List.first(socket.assigns.lista_velocidades)
      new_velocidad = if first_element.fin == "" do
        newList = List.replace_at(socket.assigns.lista_velocidades, 0, %{velocidad: socket.assigns.velocidad, tiempo: DateTime.diff(DateTime.utc_now(), first_element.ini), ini: first_element.ini, fin: DateTime.utc_now()})
        List.insert_at(newList, 0, %{velocidad: socket.assigns.velocidad - 1, tiempo: 0, ini: DateTime.utc_now(), fin: ""})
      else
        List.insert_at(socket.assigns.lista_velocidades, 0, %{velocidad: socket.assigns.velocidad, tiempo: 0, ini: first_element.ini, fin: ""})
      end
      {:noreply, assign(socket, velocidad: velocidad, lista_velocidades: new_velocidad)}
    end
  end

  defp do_something(socket, event) when event == "w" do
    cantidad = socket.assigns.top + socket.assigns.velocidad
    if cantidad > 94 or cantidad < 0 do
      {:noreply,
        socket
        |> put_flash(:error, "Fuera del límite.")}
    else
      {:noreply, assign(socket, top: cantidad)}
    end
  end
  defp do_something(socket, event) when event == "s" do
    cantidad = socket.assigns.top - socket.assigns.velocidad
    if cantidad > 100 or cantidad < 0 do
      {:noreply,
        socket
        |> put_flash(:error, "Fuera del límite.")}
    else
      {:noreply, assign(socket, top: cantidad)}
    end
  end
  defp do_something(socket, event) when event == "d" do
    cantidad = socket.assigns.left + socket.assigns.velocidad
    if cantidad > 94 or cantidad < 0 do
      {:noreply,
        socket
        |> put_flash(:error, "Fuera del límite.")}
    else
      {:noreply, assign(socket, top: socket.assigns.top, left: cantidad)}
    end
  end
  defp do_something(socket, event) when event == "a" do
    cantidad = socket.assigns.left - socket.assigns.velocidad
    if cantidad > 100 or cantidad < 0 do
      {:noreply,
        socket
        |> put_flash(:error, "Fuera del límite.")}
    else
      {:noreply, assign(socket, top: socket.assigns.top, left: cantidad)}
    end
  end

end
