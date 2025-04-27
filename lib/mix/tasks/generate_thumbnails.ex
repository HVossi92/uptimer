defmodule Mix.Tasks.Uptimer.GenerateThumbnails do
  @moduledoc """
  Mix task to generate thumbnails for existing websites.

  ## Examples

      mix uptimer.generate_thumbnails

  """
  use Mix.Task
  alias Uptimer.Websites
  alias Uptimer.Websites.Thumbnail

  @shortdoc "Generate thumbnails for existing websites"
  def run(_) do
    Mix.Task.run("app.start")
    IO.puts("Starting thumbnail generation for existing websites...")

    # Ensure thumbnail directory exists
    Thumbnail.init()

    # Get all websites
    websites = Websites.list_websites()
    total = length(websites)

    # Generate thumbnails for each website
    websites
    |> Enum.with_index(1)
    |> Enum.each(fn {website, index} ->
      IO.puts("Generating thumbnail for #{website.name} (#{index}/#{total})")
      case Websites.generate_and_save_thumbnail(website) do
        {:ok, _} ->
          IO.puts("✓ Successfully generated thumbnail for #{website.name}")
        {:error, _} ->
          IO.puts("✗ Failed to generate thumbnail for #{website.name}")
      end
    end)

    IO.puts("Thumbnail generation complete.")
  end
end
