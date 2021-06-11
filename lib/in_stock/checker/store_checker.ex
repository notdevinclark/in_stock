defmodule InStock.Checker.StoreChecker do
  @moduledoc """
  Checks a store
  """
  require Logger
  alias InStock.Stores
  alias InStock.Checker.Client

  @doc """
  Checks a website and returns :sold_out or :in_stock

  Returns Parse Error if response cannot be parsed
  """
  def check(store_id) do
    store = Stores.get_store!(store_id)

    Logger.info(message: "Checking Store", name: store.name, id: store_id)

    matcher = Regex.compile!(store.stock_matcher)
    # TODO: validate matcher in the http form

    with {:ok, document} <- get_document(store.url) do
      stock_status = get_stock_status(document, store.stock_selector, matcher)
      price = get_price(document, store.price_selector)

      {store.name, stock_status, price}
    else
      error -> {:error, store.name, "Parse Error: #{inspect(error)}"}
    end
  end

  defp get_document(url) do
    url
    |> Client.make_request!()
    |> Floki.parse_document()
  end

  defp get_stock_status(document, stock_selector, stock_matcher) do
    text =
      document
      |> Floki.find(stock_selector)
      |> Floki.text()
      |> String.downcase()

    cond do
      String.match?(text, stock_matcher) -> :sold_out
      :any_other -> :in_stock
    end
  end

  defp get_price(document, price_selector) do
    document
    |> Floki.find(price_selector)
    |> Floki.text()
    |> String.trim_leading("$")
    |> check_price()
  end

  defp check_price(""), do: :unavailable
  defp check_price(price), do: price
end
