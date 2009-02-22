module Integrity
  module Helpers
    module Urls
      def url(path)
        Addressable::URI.parse(request.url).join(path)
      end

      def root_url
        url(request.env["SCRIPT_NAME"] || "/")
      end

      def root_path(path=nil)
        root_url.to_s << "/#{path}"
      end

      def project_url(project, *paths)
        root_url.to_s << "/" << [project.permalink, *paths].join("/")
      end

      def project_path(project, *paths)
        url(project_url(project, *paths)).path.to_s
      end

      def commit_url(commit, *path)
        url commit_path(commit)
      end

      def commit_path(commit, *path)
        project_path(commit.project, "commits", commit.identifier, *path)
      end

      def push_url_for(project)
        project_url(project, "push").tap do |url|
          if Integrity.config[:use_basic_auth]
            url.user     = Integrity.config[:admin_username]
            url.password = Integrity.config[:hash_admin_password] ?
              "<password>" : Integrity.config[:admin_password]
          end
        end.to_s
      end

      def build_path(build, *path)
        warn "#build_path is deprecated, use #commit_path instead"
        commit_path build.commit, *path
      end

      def build_url(build)
        warn "#build_url is deprecated, use #commit_url instead"
        commit_url build.commit
      end
    end
  end
end
