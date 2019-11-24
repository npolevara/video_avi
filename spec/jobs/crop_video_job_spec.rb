require 'rails_helper'

RSpec.describe CropVideoJob, type: :job do

  video_path = 'spec/fixtures/files/video.mp3'

  let!(:user) { User.create }
  let!(:file) { fixture_file_upload(video_path) }
  let!(:video) { Video.create!(name: 'some name', user_id: user._id, source: file, status: 'enqueued') }

  describe '#perform_later with error' do
    it 'reports errors' do
      error_txt = 'Job failed Something went wrong'
      error = StandardError.new error_txt

      expect(Video.last.status).to eq video.status
      allow_any_instance_of(CropVideoJob).to receive(:perform).with(video._id.to_s).and_raise(error)

      CropVideoJob.perform_now(video._id.to_s)

      video.reload
      expect(video.status).to match(/\Afails:.+went wrong\z/)
    end
  end
end
