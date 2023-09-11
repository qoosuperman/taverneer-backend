# frozen_string_literal: true

json.direct_upload do
  json.url @blob.service_url_for_direct_upload
  json.headers @blob.service_headers_for_direct_upload.to_json
  json.blob_id @blob.id
  json.signed_blob_id @blob.signed_id
end
