class AiMessagesController < ApplicationController
  def index
    @ai_messages = @current_user.ai_messages.where(role: "user").order({ :created_at => :desc })

    render({ :template => "ai_messages/index.html.erb" })
  end

  def show
    @user_message = @current_user.ai_messages.find_by_id(params.fetch("path_id"))
    @assistant_message = @current_user.ai_messages.where("id > ?", @user_message.id).order(:id).first
    render({ :template => "ai_messages/show.html.erb" })
  end

  def create
    the_ai_message = @current_user.ai_messages.create(
      content: params.fetch("query_content"),
    )

    client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "system", content: @current_user.prompt }, the_ai_message.attributes.slice("role", "content")],
        temperature: 0.7,
      },
    )

    # TODO: create ai_message record with response
    ai_message_params = response.dig("choices", 0, "message")
    new_ai_message = @current_user.ai_messages.create(ai_message_params)

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
      redirect_to("/ai_messages/#{the_ai_message.id}", { :notice => "Ai message updated successfully." })
    else
      redirect_to("/ai_messages/#{the_ai_message.id}", { :alert => the_ai_message.errors.full_messages.to_sentence })
    end
  end

  def destroy
    # TODO: also delete the ai response
    the_id = params.fetch("path_id")
    the_ai_message = AiMessage.where({ :id => the_id }).at(0)

    the_ai_message.destroy

    redirect_to("/ai_messages", { :notice => "Ai message deleted successfully." })
  end
end
