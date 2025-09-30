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
end
