export default ({ env }) => ({
    email: {
      config: {
        provider: 'strapi-provider-email-smtp',
        providerOptions: {
            host: env("SMTP_HOST"), //SMTP Host
            port: Number(env("SMTP_PORT"))  , //SMTP Port
            secure: true,
            username: env("SMTP_USER"),
            password: env("SMTP_PASS"),
            rejectUnauthorized: true,
            requireTLS: true,
            connectionTimeout: 1,
        }},
      settings: {
        from: env("SMTP_USER"),
        replyTo: env("SMTP_USER"),
      },
    },
    upload: {
      config: {
        provider: 'aws-s3', // For community providers pass the full package name (e.g. provider: 'strapi-provider-upload-google-cloud-storage')
        providerOptions: {
          accessKeyId: env('AWS_ACCESS_KEY_ID'),
          secretAccessKey: env('AWS_ACCESS_SECRET'),
          region: env('AWS_REGION'),
          params: {
            Bucket: env('AWS_BUCKET'),
            directory: "strapi-media",
          },
        },
        actionOptions: {
          upload: {},
          uploadStream: {},
          delete: {},
        },
      },
    },
  });