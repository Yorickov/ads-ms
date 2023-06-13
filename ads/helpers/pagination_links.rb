# frozen_string_literal: true

module PaginationLinks
  DEFAULT_FIRST_PAGE = 1
  DEFAULT_LIMIT = 10

  def pagination_links(scope, path)
    return {} if scope.pagination_record_count.zero?

    links = {
      first: pagination_link(DEFAULT_FIRST_PAGE, path),
      last: pagination_link(scope.page_count, path)
    }

    links[:next] = pagination_link(scope.next_page, path) if scope.next_page.present?
    links[:prev] = pagination_link(scope.prev_page, path) if scope.prev_page.present?

    links
  end

  def pagination_link(page_number, path)
    [path, "page=#{page_number}"].join('?')
  end
end
