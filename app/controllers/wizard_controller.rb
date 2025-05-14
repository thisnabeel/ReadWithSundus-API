class WizardController < ApplicationController
    def ask
        prompt = "Act as an online language arts teacher. Give me an exercise for: #{params[:prompt]} "
        render json: WizardService.ask(prompt, "text")
    end
end