module ApplicationHelper
  def determine_back_path
    # Return nil or a specific path if on the contentchoice page
    return nil if current_page?(contentchoice_path)

    # Capture the query string from the current request
    query_string = request.query_string.present? ? "?#{request.query_string}" : ""

    # Determine the base path based on the current page
    base_path = if current_page?(bookmarks_path)
                  moods_path
                elsif current_page?(moods_path)
                  contentchoice_path
                else
                  # Use the referer if available, or root_path as fallback
                  request.referer || root_path
                end

    # Append the query string to the base path if not using referer
    base_path == request.referer || base_path == root_path ? base_path : base_path + query_string
  end
end
