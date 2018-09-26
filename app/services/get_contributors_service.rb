require 'net/http'

class GetContributorsService
  attr_reader :error, :value

  def initialize(params)
    @params = params
    @error = nil
    @value = nil
  end

  def call
    if response.is_a? Array
      Rails.cache.write("#{owner}/#{repo}", result, expires_in: 1.day)
      @value = {source: "#{owner}/#{repo}", result: result}
    else
      @error = response["message"]
    end
  end

  private

  attr_reader :params

  def owner
    @owner ||= params[:contributors][:str].split('/')[-2]
  end

  def repo
    @repo ||= params[:contributors][:str].split('/')[-1]
  end

  def github_url
    "https://api.github.com/repos/#{owner}/#{repo}/contributors"
  end

  def response
    @contributors ||= JSON.parse(Net::HTTP.get(URI(github_url)))
  rescue => e
    @error = e.message
  end

  def first_contributor
    response.first["login"] if response.first
  end

  def second_contributor
    response.second["login"] if response.second
  end

  def third_contributor
    response.third["login"] if response.third
  end

  def result
    [first_contributor, second_contributor, third_contributor].compact
  end
end
