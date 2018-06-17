class Voice::ApplicationController < ApplicationController
  include VoiceRequestValidator
  include Localizer
end
