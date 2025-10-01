module ApplicationHelper
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
    base_classes = ["rounded-full border border-slate-800 object-cover", classes].reject(&:blank?).join(" ")

    if user&.avatar&.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]).processed,
                class: base_classes,
                alt: user.display_name,
                width: size,
                height: size
    else
      initials = user&.display_name.to_s.split.map(&:first).join[0, 2].to_s.upcase
      initials = user&.username.to_s[0, 2].upcase if initials.blank?
      content_tag :span, initials,
                  class: ["flex items-center justify-center rounded-full bg-slate-800 text-xs font-semibold text-slate-200", classes].reject(&:blank?).join(" "),
                  style: "width: #{size}px; height: #{size}px;"
    end
  end
end
