# encoding: utf-8

# Set the default text field size when input is a string. Default is nil.
# Formtastic::SemanticFormBuilder.default_text_field_size = 50

# Set the default text area height when input is a text. Default is 20.
# Formtastic::SemanticFormBuilder.default_text_area_height = 5

# Set the default text area width when input is a text. Default is nil.
# Formtastic::SemanticFormBuilder.default_text_area_width = 50

# Should all fields be considered "required" by default?
# Rails 2 only, ignored by Rails 3 because it will never fall back to this default.
# Defaults to true.
# Formtastic::SemanticFormBuilder.all_fields_required_by_default = true

# Should select fields have a blank option/prompt by default?
# Defaults to true.
# Formtastic::SemanticFormBuilder.include_blank_for_select_by_default = true

# Set the string that will be appended to the labels/fieldsets which are required
# It accepts string or procs and the default is a localized version of
# '<abbr title="required">*</abbr>'. In other words, if you configure formtastic.required
# in your locale, it will replace the abbr title properly. But if you don't want to use
# abbr tag, you can simply give a string as below
# Formtastic::SemanticFormBuilder.required_string = "(required)"

# Set the string that will be appended to the labels/fieldsets which are optional
# Defaults to an empty string ("") and also accepts procs (see required_string above)
# Formtastic::SemanticFormBuilder.optional_string = "(optional)"

# Set the way inline errors will be displayed.
# Defaults to :sentence, valid options are :sentence, :list, :first and :none
# Formtastic::SemanticFormBuilder.inline_errors = :sentence
# Formtastic uses the following classes as default for hints, inline_errors and error list

# If you override the class here, please ensure to override it in your formtastic_changes.css stylesheet as well
# Formtastic::SemanticFormBuilder.default_hint_class = "inline-hints"
# Formtastic::SemanticFormBuilder.default_inline_error_class = "inline-errors"
# Formtastic::SemanticFormBuilder.default_error_list_class = "errors"

# Set the method to call on label text to transform or format it for human-friendly
# reading when formtastic is used without object. Defaults to :humanize.
# Formtastic::SemanticFormBuilder.label_str_method = :humanize

# Set the array of methods to try calling on parent objects in :select and :radio inputs
# for the text inside each @<option>@ tag or alongside each radio @<input>@. The first method
# that is found on the object will be used.
# Defaults to ["to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]
# Formtastic::SemanticFormBuilder.collection_label_methods = [
#   "to_label", "display_name", "full_name", "name", "title", "username", "login", "value", "to_s"]

# Formtastic by default renders inside li tags the input, hints and then
# errors messages. Sometimes you want the hints to be rendered first than
# the input, in the following order: hints, input and errors. You can
# customize it doing just as below:
# Formtastic::SemanticFormBuilder.inline_order = [:input, :errors, :hints]

# Additionally, you can customize the order for specific types of inputs.
# This is configured on a type basis and if a type is not found it will
# fall back to the default order as defined by #inline_order
# Formtastic::SemanticFormBuilder.custom_inline_order[:checkbox] = [:errors, :hints, :input]
# Formtastic::SemanticFormBuilder.custom_inline_order[:select] = [:hints, :input, :errors]

# Specifies if labels/hints for input fields automatically be looked up using I18n.
# Default value: false. Overridden for specific fields by setting value to true,
# i.e. :label => true, or :hint => true (or opposite depending on initialized value)
Formtastic::SemanticFormBuilder.i18n_lookups_by_default = true

# You can add custom inputs or override parts of Formtastic by subclassing SemanticFormBuilder and
# specifying that class here.  Defaults to SemanticFormBuilder.
# Formtastic::SemanticFormHelper.builder = MyCustomBuilder

# 225:       def link_to(*args, &block)
# 226:         if block_given?
# 227:           options      = args.first || {}
# 228:           html_options = args.second
# 229:           link_to(capture(&block), options, html_options)
# 230:         else
# 231:           name         = args[0]
# 232:           options      = args[1] || {}
# 233:           html_options = args[2]
# 234: 
# 235:           html_options = convert_options_to_data_attributes(options, html_options)
# 236:           url = url_for(options)
# 237: 
# 238:           href = html_options['href']
# 239:           tag_options = tag_options(html_options)
# 240: 
# 241:           href_attr = "href=\"#{html_escape(url)}\"" unless href
# 242:           "<a #{href_attr}#{tag_options}>#{html_escape(name || url)}</a>".html_safe
# 243:         end
# 244:       end



module Formtastic
  class SemanticFormBuilder
    def field_set_title_from_args(*args) #:nodoc:
      options = args.extract_options!
#      options[:name] ||= options.delete(:title)
      title = options[:name]

      if title.blank?
        valid_name_classes = [::String, ::Symbol]
        valid_name_classes.delete(::Symbol) if !block_given? && (args.first.is_a?(::Symbol) && content_columns.include?(args.first))
        title = args.shift if valid_name_classes.any? { |valid_name_class| args.first.is_a?(valid_name_class) }
      end
      title = localized_string(title, title, :title) if title.is_a?(::Symbol)
      title
    end
    def cancel_button(*args, &block)
      if block_given?
        options      = args.first || {}
        html_options = args.second
        template.content_tag(:li, :class => 'cancel') do
          template.link_to(capture(&block), options, html_options)
        end
      else
        name         = (args.length == 1) ? I18n.t('.cancel') : args[0]
        options      = args[1] || {}
        options      = args[0] if args.length == 1
        html_options = args[2] || {}
        
        
        template.content_tag(:li, :class => 'cancel') do
          template.link_to(name, options, html_options)
        end
      end
    end
  end
end



