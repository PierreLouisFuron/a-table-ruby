module ApplicationHelper
  include Pagy::Frontend

  # Wraps image_tag with a lazy-loading shimmer placeholder.
  # Accepts the same arguments as image_tag.
  #
  #   lazy_image_tag(recipe.get_cover_thumbnail, class: "img-fluid", alt: "photo")
  #
  def lazy_image_tag(source, options = {})
    wrapper_class = ["lazy-image", options.delete(:wrapper_class)].compact.join(" ")
    wrapper_html  = options.delete(:wrapper_html) || {}

    options[:loading] ||= "lazy"
    options[:data] = (options[:data] || {}).merge(
      lazy_image_target: "img",
      action: "load->lazy-image#reveal"
    )

    content_tag(:div, image_tag(source, options),
      class: wrapper_class,
      data: { controller: "lazy-image" },
      **wrapper_html
    )
  end
end
