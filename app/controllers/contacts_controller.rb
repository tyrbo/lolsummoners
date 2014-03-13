class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if verify_recaptcha(model: @contact, message: 'Invalid reCAPTCHA')
      if @contact.deliver
        redirect_to root_path, notice: 'Thank you for your message!'
      else
        flash.now[:error] = 'Some entries were incorrect or missing.'
        render :new
      end
    else
      flash.now[:error] = 'Invalid reCAPTCHA!'
      render :new
    end
  end
end
