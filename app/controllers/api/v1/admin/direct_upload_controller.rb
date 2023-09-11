# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DirectUploadController < BaseController
        # Direct Upload API 使用方式：
        # 1. 計算檔案的 binary md5 後用 base64 表示（[AWS 相關文件][3])
        # 例如: one.txt 只有 1\n（共2 bytes），那麼 `openssl md5 -binary one.txt | base64` 就會回傳 `sCYyTGkEsqnLS4jW1hyB0Q==`
        # 2. 呼叫這個 API 成功後取得 url / headers / signed_blob_id
        # 3. 帶著 headers 用 PUT 方法對 <url> 上傳檔案，回傳 200 OK 就代表上傳 AWS S3 成功了
        # 例如: curl -X PUT <url> -H <headers[0]> -H <headers[1]> --data-binary my-avatar.png
        # 4. 把 signed_blob_id 更新到相關的 record 上，例如 Recipe.first.cover_image.attach(<signed_blob_id>)

        # [1]: https://evilmartians.com/chronicles/active-storage-meets-graphql-direct-uploads
        # [2]: https://guides.rubyonrails.org/active_storage_overview.html#integrating-with-libraries-or-frameworks
        # [3]: https://aws.amazon.com/tw/premiumsupport/knowledge-center/data-integrity-s3/
        def create
          @blob = ActiveStorage::Blob.create_before_direct_upload!(**direct_upload_params.to_h.symbolize_keys)

          render formats: [:json]
        end

        private

        def direct_upload_params
          params.require(:input)
                .permit(:filename, :byte_size, :checksum, :content_type)
        end
      end
    end
  end
end
