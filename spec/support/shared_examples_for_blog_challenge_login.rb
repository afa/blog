RSpec.shared_context('with auth challenge') do
  let(:source) { Sync::Source.new(api_url: 'http://localhost/', login_options: login_opts) }
  let(:login_opts) { { 'user_key' => 'a', 'user_pass_hash' => 'b' } }
  let(:challenge_resp) {
    {
      'auth_scheme' => 'c0',
      'challenge' => 'c0:1714208400:2269:60:yh8Vk9qOWzmm4VxAreoH:7c7dc2ee098a27fbb78b119235082ed9',
      'expire_time' => '1714210729',
      'server_time' => '1714210669',
      'success' => 'OK'
    }
  }
  let(:ch_opts) {
    {
      'user' => login_opts['user_key'],
      'auth_method' => 'challenge',
      'auth_challenge' => challenge_resp['challenge'],
      'auth_response' => Digest::MD5.hexdigest(challenge_resp['challenge'] + login_opts['user_pass_hash'])
    }
  }

  before do
    allow(request_handler).to(
      receive(:call)
      .with({ 'mode' => 'getchallenge' }, source:)
      .and_return(Success(challenge_resp))
    )
  end
end
