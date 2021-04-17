# frozen_string_literal: true

module TugoCommon
  class GrpcService
    def self.call_grpc(auth_header, hostname, service, method, params = {}, client_options = {})
      client = ::Gruf::Client.new(
        service: service,
        options: { hostname: hostname },
        client_options: {
          timeout: ENV.fetch('GRPC_CALL_TIMEOUT') { 20 }.to_i,
          interceptors: [
            Gruf::StackdriverTrace::ClientInterceptor.new
          ],
          channel_args: {
            'grpc.max_send_message_length' => -1,
            'grpc.max_receive_message_length' => -1
          }
        }.merge(client_options.to_h)
      )

      metadata = auth_header.nil? ? {} : { authorrization: auth_header }

      client.call(method, params, metadata)
    end
  end
end
