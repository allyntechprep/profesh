class AiMessagesController < ApplicationController
  def index
    matching_ai_messages = AiMessage.all

    @list_of_ai_messages = matching_ai_messages.order({ :created_at => :desc })

    render({ :template => "ai_messages/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_ai_messages = AiMessage.where({ :id => the_id })

    @the_ai_message = matching_ai_messages.at(0)

    render({ :template => "ai_messages/show.html.erb" })
  end

  def create
    the_ai_message = AiMessage.new
    the_ai_message.user_id = params.fetch("query_user_id")
    the_ai_message.content = params.fetch("query_content")
    the_ai_message.role = params.fetch("query_role")

    if the_ai_message.valid?
      the_ai_message.save
      redirect_to("/ai_messages", { :notice => "Ai message created successfully." })
    else
      redirect_to("/ai_messages", { :alert => the_ai_message.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_ai_message = AiMessage.where({ :id => the_id }).at(0)

    the_ai_message.user_id = params.fetch("query_user_id")
    the_ai_message.content = params.fetch("query_content")
    the_ai_message.role = params.fetch("query_role")

    if the_ai_message.valid?
      the_ai_message.save
      redirect_to("/ai_messages/#{the_ai_message.id}", { :notice => "Ai message updated successfully."} )
    else
      redirect_to("/ai_messages/#{the_ai_message.id}", { :alert => the_ai_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_ai_message = AiMessage.where({ :id => the_id }).at(0)

    the_ai_message.destroy

    redirect_to("/ai_messages", { :notice => "Ai message deleted successfully."} )
  end
end
