defmodule Uptimer.Websites.Thumbnail do
  @moduledoc """
  Service for generating website thumbnails using ChromicPDF.
  """
  require Logger

  # Fix the priv_dir calculation to work in both development and release mode
  @priv_dir :code.priv_dir(:uptimer)
  @thumbnail_dir Path.join([@priv_dir, "static", "uploads", "thumbnails"])
  @thumbnail_path_prefix "/uploads/thumbnails"

  def init do
    # Ensure the thumbnail directory exists and log where it's being created
    File.mkdir_p!(@thumbnail_dir)
    Logger.info("Thumbnail directory initialized at: #{@thumbnail_dir}")
  end

  @doc """
  Generates a thumbnail for the given website URL and saves it to the static file path.
  Returns the relative URL path to the thumbnail.
  """
  @spec generate_thumbnail(String.t()) :: {:ok, String.t()} | {:error, any()}
  def generate_thumbnail(url) do
    # First delete any existing thumbnails for this URL
    delete_thumbnails_for_url(url)

    sanitized_url = sanitize_url(url)
    # Use WebP format instead of PNG for better compression
    filename = "#{generate_filename(sanitized_url)}.webp"
    full_path = Path.join(@thumbnail_dir, filename)

    # Log the path where we're saving the file
    Logger.info("Generating thumbnail at path: #{full_path}")

    case generate_screenshot(sanitized_url, full_path) do
      :ok ->
        # Screenshot was successfully saved to the output path
        thumbnail_url = Path.join(@thumbnail_path_prefix, filename)
        Logger.info("Screenshot generated successfully: #{thumbnail_url}")
        {:ok, thumbnail_url}

      {:ok, _} ->
        # Some versions might return {:ok, path}
        thumbnail_url = Path.join(@thumbnail_path_prefix, filename)
        Logger.info("Screenshot generated successfully: #{thumbnail_url}")
        {:ok, thumbnail_url}

      error ->
        Logger.error("Failed to generate thumbnail for #{url}: #{inspect(error)}")
        {:error, error}
    end
  end

  @doc """
  Generates a filename for the given URL.
  """
  def generate_filename(url) do
    url
    |> URI.parse()
    |> Map.get(:host, url)
    |> String.replace(~r/[^a-zA-Z0-9]/, "-")
    |> then(fn host -> "#{host}-#{Base.encode16(:crypto.strong_rand_bytes(4), case: :lower)}" end)
  end

  @doc """
  Ensures the URL has http:// prefix.
  """
  def sanitize_url(url) do
    if String.starts_with?(url, ["http://", "https://"]) do
      url
    else
      "https://#{url}"
    end
  end

  @doc """
  Deletes all thumbnail files associated with a specific URL.
  """
  def delete_thumbnails_for_url(url) do
    # Extract the domain from the URL
    domain_pattern =
      url
      |> sanitize_url()
      |> URI.parse()
      |> Map.get(:host, url)
      |> String.replace(~r/[^a-zA-Z0-9]/, "-")

    # Create a pattern to match all thumbnails for this domain
    # Search for both png and webp formats
    [
      @thumbnail_dir |> Path.join("#{domain_pattern}-*.png"),
      @thumbnail_dir |> Path.join("#{domain_pattern}-*.webp")
    ]
    |> Enum.flat_map(&Path.wildcard/1)
    |> Enum.each(fn file_path ->
      Logger.info("Deleting thumbnail: #{file_path}")
      File.rm(file_path)
    end)
  end

  defp generate_screenshot(url, output_path) do
    try do
      ChromicPDF.capture_screenshot(
        {:url, url},
        output: output_path,
        capture_screenshot: %{
          format: "webp",
          quality: 75,
          clip: %{x: 0, y: 0, width: 1125, height: 788, scale: 0.4}
        },
        # Removed wait_for option - using delay instead which is more compatible
        delay: 1500,
        timeout: 20_000
      )
    rescue
      e ->
        Logger.error("Error generating screenshot: #{inspect(e)}")
        {:error, "Screenshot generation failed"}
    end
  end
end
