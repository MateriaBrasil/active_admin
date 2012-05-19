module ActiveAdmin
  class FormBuilder < ::Formtastic::FormBuilder

<<<<<<< HEAD
    attr_reader :form_buffers

    def initialize(*args)
      @form_buffers = ["".html_safe]
      super
    end

    def inputs(*args, &block)
      # Store that we are creating inputs without a block
      @inputs_with_block = block_given? ? true : false
      content = with_new_form_buffer { super }
      form_buffers.last << content.html_safe
    end

    # The input method returns a properly formatted string for
    # its contents, so we want to skip the internal buffering
    # while building up its contents
    def input(method, *args)
      content = with_new_form_buffer { super }
      return content.html_safe unless @inputs_with_block
      form_buffers.last << content.html_safe
    end

    # The buttons method always needs to be wrapped in a new buffer
    def buttons(*args, &block)
      content = with_new_form_buffer do
        block_given? ? super : super { commit_button_with_cancel_link }
      end
      form_buffers.last << content.html_safe
    end

    def commit_button(*args)
      content = with_new_form_buffer{ super }
      form_buffers.last << content.html_safe
    end

    def cancel_link(url = nil, html_options = {}, li_attributes = {})
      li_attributes[:class] ||= "cancel"
      url ||= {:action => "index"}
      template.content_tag(:li, (template.link_to I18n.t('active_admin.cancel'), url, html_options), li_attributes)
    end

    def commit_button_with_cancel_link
      content = commit_button
      content << cancel_link
=======
    def datepicker_input(method, options)
      options = options.dup
      options[:input_html] ||= {}
      options[:input_html][:class] = [options[:input_html][:class], "datepicker"].compact.join(' ')
      options[:input_html][:size] ||= "10"
      string_input(method, options)
>>>>>>> origin/dsl_form_builder
    end

    def has_many(association, options = {}, &block)
      options = { :for => association }.merge(options)
      options[:class] ||= ""
      options[:class] << "inputs has_many_fields"

      # Add Delete Links
      form_block = proc do |has_many_form|
        fields = template.capture(has_many_form, &block)

        onclick = if has_many_form.object.new_record?
          "$(this).closest('.has_many_fields').remove(); return false;"
        else
          "$(this).closest('.has_many_fields').slideUp().find('.destroy').val('1'); return false;"
        end

        delete_button = template.content_tag :li do
          template.link_to I18n.t('active_admin.has_many_delete'), "#", :onclick => onclick, :class => "button"
        end

        fields + delete_button
      end

      template.content_tag :div, :class => "has_many #{association}" do
        buffer = "".html_safe
        buffer << template.content_tag(:h3, association.to_s.titlecase)
        buffer << inputs(options, &form_block)

        # Capture the ADD JS
        js = inputs_for_nested_attributes :for => [association, object.class.reflect_on_association(association).klass.new],
                                          :class => "inputs has_many_fields",
                                          :for_options => {
                                            :child_index => "NEW_RECORD"
                                          }, &form_block

        js = template.escape_javascript(js)
        js = template.link_to I18n.t('active_admin.has_many_new', :model => association.to_s.singularize.titlecase), "#", :onclick => "$(this).before('#{js}'.replace(/NEW_RECORD/g, new Date().getTime())); return false;", :class => "button"

        buffer << js
      end
<<<<<<< HEAD
      form_buffers.last << content.html_safe
    end

    protected

    def active_admin_input_class_name(as)
      "ActiveAdmin::Inputs::#{as.to_s.camelize}Input"
    end

    def input_class(as)
      @input_classes_cache ||= {}
      @input_classes_cache[as] ||= begin
        begin
          begin
            custom_input_class_name(as).constantize
          rescue NameError
            begin
              active_admin_input_class_name(as).constantize
            rescue NameError
              standard_input_class_name(as).constantize
            end
          end
        rescue NameError
          raise Formtastic::UnknownInputError
        end
      end
    end

    private

    def with_new_form_buffer
      form_buffers << "".html_safe
      return_value = yield
      form_buffers.pop
      return_value
=======
>>>>>>> origin/dsl_form_builder
    end

  end
end
