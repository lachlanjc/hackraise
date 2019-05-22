require 'spec_helper'

describe Conversation do
  subject { build(:conversation) }

  let(:message) { build(:message) }

  it "is valid" do
    expect(subject).to be_valid
  end

  it "is not archived" do
    expect(subject).to_not be_archived
  end

  it "is reopened when new messages are added" do
    subject.archived = true
    subject.messages << message
    expect(subject).to_not be_archived
  end

  describe "#unarchive!" do
    before do
      subject.save
      subject.unarchive!
    end

    it "archives the conversation" do
      expect(subject).to_not be_archived
    end
  end

  describe "#archive!" do
    before do
      subject.save
      subject.archive!
    end

    it "archives the conversation" do
      expect(subject).to be_archived
    end
  end

  describe '#just_archived?' do
    before { subject.save }

    it 'knows when a conversation has been archived' do
      expect(subject).to_not be_just_archived

      subject.archive!

      expect(subject).to be_just_archived
    end
  end

  describe '#just_unarchived?' do
    before { subject.save }

    it 'knows when a conversation has been unarchived' do
      subject.archive!

      expect(subject).to_not be_just_unarchived

      subject.unarchive!

      expect(subject).to be_just_unarchived
    end
  end

  describe "#mailbox_email" do
    before { subject.save }

    it "must return a valid email" do
      expect(subject.mailbox_email.address).to_not be_empty
    end

    it "must have the correct local part" do
      subject.save
      expect(subject.mailbox_email.local).to eq(subject.id)
    end

    it "must have the correct domain part" do
      subject.save
      expect(subject.mailbox_email.domain).to eq(Hackraise.incoming_email_domain)
    end

    it "must have the correct display name" do
      subject.save
      expect(subject.mailbox_email.display_name).to eq(subject.account.name)
    end
  end

  describe ".match_mailbox" do
    it "matches a mailbox email to a conversation" do
      subject.save
      expect(described_class.match_mailbox(subject.mailbox_email.to_s)).to eq(subject)
    end
  end

  describe "#most_recent_message" do
    it "returns the most recently updated message" do
      subject.save
      _old_message = create(:message, conversation: subject, updated_at: 10.minutes.ago)
      new_message = create(:message, conversation: subject, updated_at: 1.minute.ago)

      expect(subject.most_recent_message).to eq(new_message)
    end
  end

  describe "#last_activity_at" do
    it "returns the updated at timestamp of the most recent message" do
      most_recent_message = double("Message", updated_at: Time.utc(2014, 3, 24, 12, 0, 0))

      allow(subject).to receive(:most_recent_message) { most_recent_message }

      expect(subject.last_activity_at).to eq(Time.utc(2014, 3, 24, 12, 0, 0))
    end

    it "uses the conversation updated at timestamp if there are no messages" do
      allow(subject).to receive(:most_recent_message) { nil }
      allow(subject).to receive(:updated_at) { Time.utc(2014, 3, 24, 12, 0, 0) }

      expect(subject.last_activity_at).to eq(Time.utc(2014, 3, 24, 12, 0, 0))
    end
  end

  describe '#subject' do
    let(:conversation) { build(:conversation) }

    it 'returns the subject if it exists' do
      conversation.subject = 'Can haz help?'

      expect(conversation.subject).to eq('Can haz help?')
    end
  end
end
