require 'rails_helper'

RSpec.describe 'coordinate_upload', type: :request do
  include RequestHelper
  include ActionDispatch::TestProcess

  describe 'POST /user/update' do
    let(:update_structure) do
      {
        'name' => a_kind_of(String),
        'profile_url' => a_kind_of(String),
      }
    end

    let(:path) { '/user/update' }

    context 'パラメータが正しいとき' do
      before do
        params[:name] = 'upload-man'
        params[:profile] = fixture_file_upload("img/sample.png", 'image/png')
        env['Content-Type'] = 'multipart/form-data'
      end

      it '200 が返ってくる' do
        post path, params, env
        expect(response).to have_http_status(200)
      end

      it '写真をアップロードする' do
        post path, params, env
        json = JSON.parse(response.body)

        expect(json).to match(update_structure)
      end

      it 'User が 1 増える' do
        expect {
          post path, params, env
        }.to change(User, :count).by(1)
      end
    end

    context 'nameが入っていないとき' do
      before do
        params[:name] = nil
        params[:profile] = fixture_file_upload("img/sample.png", 'image/png')
        env['Content-Type'] = 'multipart/form-data'
      end

      it '400 が返ってくる' do
        post path, params, env
        expect(response).to have_http_status(400)
      end

      it 'User が増減しない' do
        expect {
          post path, params
        }.not_to change(User, :count)
      end
    end

    context 'profileが入っていないとき' do
      before do
        params[:name] = 'upload-man'
        params[:profile] = nil
        env['Content-Type'] = 'multipart/form-data'
      end

      it '400 が返ってくる' do
        post path, params, env
        expect(response).to have_http_status(400)
      end

      it 'invalid params が返ってくる' do
        post path, params, env
        json = JSON.parse(response.body)

        expect(json['message']).to eq('invalid params')
      end

      it 'User が増減しない' do
        expect {
          post path, params
        }.not_to change(User, :count)
      end
    end
  end

  describe 'POST /user/update_base64' do
    let(:update_base64_structure) do
      {
        'name' => a_kind_of(String),
        'profile_url' => a_kind_of(String),
      }
    end

    let(:path) { '/user/update_base64' }

    context 'パラメータが正しいとき' do
      before do
        params[:name] = 'upload-man'
        params[:profile_base64] = base64_image_param("#{Rails.root}/spec/fixtures/img/sample.png")
        env['Content-Type'] = 'application/json'
      end

      it '200 が返ってくる' do
        post path, params.to_json, env
        expect(response).to have_http_status(200)
      end

      it '写真をアップロードする' do
        post path, params.to_json, env
        json = JSON.parse(response.body)

        expect(json).to match(update_base64_structure)
      end

      it 'User が 1 増える' do
        expect {
          post path, params.to_json, env
        }.to change(User, :count).by(1)
      end
    end

    context 'nameが入っていないとき' do
      before do
        params[:name] = nil
        params[:profile_base64] = base64_image_param("#{Rails.root}/spec/fixtures/img/sample.png")
        env['Content-Type'] = 'multipart/form-data'
      end

      it '400 が返ってくる' do
        post path, params.to_json, env
        expect(response).to have_http_status(400)
      end

      it 'User が増減しない' do
        expect {
          post path, params.to_json, env
        }.not_to change(User, :count)
      end
    end

    context 'profile_base64が入っていないとき' do
      before do
        params[:name] = 'upload-man'
        params[:profile_base64] = nil
        env['Content-Type'] = 'application/json'
      end

      it '400 が返ってくる' do
        post path, params.to_json, env
        expect(response).to have_http_status(400)
      end

      it 'invalid params が返ってくる' do
        post path, params.to_json, env
        json = JSON.parse(response.body)

        expect(json['message']).to eq('invalid params')
      end

      it 'User が増減しない' do
        expect {
          post path, params.to_json, env
        }.not_to change(User, :count)
      end
    end
  end
end
