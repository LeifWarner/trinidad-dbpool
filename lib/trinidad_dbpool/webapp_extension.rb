module Trinidad
  module Extensions
    class DbpoolWebAppExtension < WebAppExtension
      def configure(tomcat, app_context)
        jndi = @options.delete(:jndi)
        url = @options.delete(:url)
        url = protocol + url unless %r{^#{protocol}} =~ url
        @options[:url] = url

        resource = Trinidad::Tomcat::ContextResource.new
        resource.setAuth(@options.delete(:auth)) if @options.has_key?(:auth) 
        resource.setName(jndi)
        resource.setType("javax.sql.DataSource")
        resource.setDescription(@options.delete(:description)) if @options.has_key?(:description)

        @options.each do |key, value|
          resource.setProperty(key.to_s, value.to_s)
        end

        resource.setProperty("driverClassName", driver_name)

        app_context.naming_resources.add_resource(resource)
        app_context.naming_resources = resource.naming_resources

        resource
      end
    end
  end
end
