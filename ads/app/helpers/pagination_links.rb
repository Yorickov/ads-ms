# frozen_string_literal: true

module PaginationLinks
  def pagination_links(dataset)
    return {} if dataset.pagination_record_count.zero?

    links = {
      first: pagination_link(1),
      last: pagination_link(dataset.page_count)
    }

    links[:next] = pagination_link(dataset.next_page) if dataset.next_page.present?
    links[:prev] = pagination_link(dataset.prev_page) if dataset.prev_page.present?

    links
  end

  def pagination_link(page_number)
    qs = request.GET.merge('page' => page_number).to_query
    [request.path, qs].join('?')
  end
end
