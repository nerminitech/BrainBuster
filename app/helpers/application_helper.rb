module ApplicationHelper
  include Pagy::Frontend

  def nav_link_classes(path)
    base = "transition-colors hover:text-emerald-300"
    current_page?(path) ? "text-emerald-400 #{base}" : "text-slate-300 #{base}"
  end

  def difficulty_badge(difficulty)
    colors = {
      "leicht" => "bg-emerald-500/20 text-emerald-200",
      "mittel" => "bg-blue-500/20 text-blue-200",
      "schwer" => "bg-amber-500/20 text-amber-200",
      "experte" => "bg-rose-500/20 text-rose-200"
    }
    klass = colors.fetch(difficulty, "bg-slate-500/20 text-slate-200")
    content_tag(:span, difficulty.titleize, class: "rounded-full px-3 py-1 text-xs font-semibold #{klass}")
  end

  def avatar_for(user, size: 48, classes: "")
    base_classes = [ "rounded-full border border-slate-800 object-cover", classes ].reject(&:blank?).join(" ")

    if user&.avatar&.attached?
      image_tag user.avatar.variant(resize_to_fill: [ size, size ]).processed,
                class: base_classes,
                alt: user.display_name,
                width: size,
                height: size
    else
      render "shared/default_avatar", size: size, classes: base_classes
    end
  end

  def pagy_nav_slate(pagy)
    return if pagy.pages <= 1

    content_tag :nav, class: "pagy-nav mt-6 flex justify-center" do
      content_tag :ul, class: "inline-flex items-center gap-2 rounded-full border border-slate-800 bg-slate-900/70 px-3 py-2 shadow-lg shadow-emerald-500/10" do
        safe_join([
          pagination_prev_button(pagy),
          *pagination_page_buttons(pagy),
          pagination_next_button(pagy)
        ])
      end
    end
  end

  private

  def pagination_prev_button(pagy)
    label = raw("&larr;")
    if pagy.prev
      content_tag :li do
        link_to label, pagy_url_for(pagy, pagy.prev), class: pagination_link_classes
      end
    else
      content_tag :li, content_tag(:span, label, class: pagination_disabled_classes)
    end
  end

  def pagination_next_button(pagy)
    label = raw("&rarr;")
    if pagy.next
      content_tag :li do
        link_to label, pagy_url_for(pagy, pagy.next), class: pagination_link_classes
      end
    else
      content_tag :li, content_tag(:span, label, class: pagination_disabled_classes)
    end
  end

  def pagination_page_buttons(pagy)
    pages = pagination_pages(pagy)

    pages.map do |item|
      case item
      when Integer
        if item == pagy.page
          content_tag :li, content_tag(:span, item, class: pagination_active_classes)
        else
          content_tag :li do
            link_to item, pagy_url_for(pagy, item), class: pagination_link_classes
          end
        end
      else
        content_tag :li, content_tag(:span, "…", class: pagination_disabled_classes)
      end
    end
  end

  def pagination_link_classes
    "rounded-full px-3 py-1 text-sm font-medium text-slate-200 transition hover:bg-emerald-500/20 hover:text-emerald-200"
  end

  def pagination_active_classes
    "rounded-full bg-emerald-500 px-3 py-1 text-sm font-semibold text-white shadow shadow-emerald-500/40"
  end

  def pagination_disabled_classes
    "rounded-full px-3 py-1 text-sm font-medium text-slate-500"
  end

  def pagination_pages(pagy)
    return (1..pagy.pages).to_a if pagy.pages <= 7

    pages = [ 1 ]
    start_page = [ pagy.page - 1, 2 ].max
    end_page = [ pagy.page + 1, pagy.pages - 1 ].min

    pages << :gap if start_page > 2
    pages.concat((start_page..end_page).to_a)
    pages << :gap if end_page < pagy.pages - 1
    pages << pagy.pages
    pages
  end
end
