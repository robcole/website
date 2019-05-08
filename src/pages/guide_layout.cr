abstract class GuideLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  needs title : String
  needs guide_action : GuideAction.class
  needs markdown : String

  def page_title
    @title
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead.new(page_title: page_title, context: @context)

      body class: "font-sans text-grey-darkest leading-tight bg-grey-lighter" do
        mount Shared::Header.new(@context.request)
        middle_section
        guide_content
      end
    end
  end

  def middle_section
    div class: "bg-green-gradient" do
      div class: "flex relative py-8 pr-10 container mx-auto text-white" do
        table_of_contents
        mount Guides::Sidebar.new(@guide_action)
      end
    end
  end

  def guide_content
    div class: "flex container mx-auto" do
      div class: "ml-sidebar guide-content" do
        content
      end
    end
  end

  def table_of_contents
    div class: "mt-5 ml-sidebar" do
      h1 @title, class: "font-normal font-xl text-white text-shadow mb-6 tracking-medium"
      ul class: "list-reset text-shadow text-lg mb-4 #{guide_sections.size > 6 && "split-columns"}" do
        guide_sections.each do |section|
          li do
            link "##{GenerateHeadingAnchor.new(section).call}", class: "text-white block py-1 no-underline " do
              span "#", class: "text-teal-lighter mr-2 hover:no-underline"
              span section, class: "border-b border-teal-light mr-3 hover:border-white"
            end
          end
        end
      end
    end
  end

  def guide_sections
    @markdown.split("\n").select(&.starts_with?("## ")).map(&.gsub("## ", ""))
  end
end