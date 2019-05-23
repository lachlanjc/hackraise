const conversationPath = props =>
  '/accounts/' +
  props.accountSlug +
  '/conversations/' +
  props.conversationNumber +
  '.json'

const inboxPath = props => '/' + props.accountSlug + '/inbox'

const archivePath = props => '/' + props.accountSlug + '/archived'

var ConversationView = React.createClass({
  getInitialState: function() {
    return {
      conversation: null,
      archived: false
    }
  },

  componentDidMount: function() {
    this.getConversation()
  },

  getConversation: function() {
    $.getJSON(
      this.conversationPath(),
      function(res) {
        var conversation = res.conversation
        const { archived } = conversation
        conversation.expanded = true
        this.setState({ conversation, archived })
      }.bind(this)
    )
  },

  // TODO: Clean up duplication on ConversationList
  addStreamItemHandler: function(streamItem) {
    var conversation = this.state.conversation

    switch (streamItem.type) {
      case 'message':
        conversation.messages.push(streamItem)
        break
      case 'assignmentevent':
        conversation.assignment_events.push(streamItem)
        break
      case 'tagevent':
        conversation.tag_events.push(streamItem)
        break
    }

    this.setState({ conversation })
  },

  // TODO: Clean up duplication on ConversationList
  archiveHandler: function(event) {
    event.stopPropagation()
    event.preventDefault()

    var data = {
      conversation: {
        archive: true
      }
    }

    $.ajax({
      type: 'PUT',
      url: this.state.conversation.path,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      accepts: { json: 'application/json' },
      success: function() {
        var conversation = this.state.conversation
        conversation.archived = true
        this.setState({ conversation })
      }.bind(this)
    })
  },

  unarchiveHandler: function(event) {
    event.stopPropagation()
    event.preventDefault()

    var data = {
      conversation: {
        unarchive: true
      }
    }

    $.ajax({
      type: 'PUT',
      url: this.state.conversation.path,
      data: JSON.stringify(data),
      dataType: 'json',
      contentType: 'application/json',
      accepts: { json: 'application/json' },
      success: function() {
        var conversation = this.state.conversation
        conversation.archived = false
        this.setState({ conversation })
      }.bind(this)
    })
  },

  renderMailboxLink: function() {
    if (this.state.archived) {
      return (
        <a href={this.archivePath(this.props)} className="text-muted">
          Back to Archive
        </a>
      )
    } else {
      return (
        <a href={this.inboxPath(this.props)} className="text-muted">
          Back to Inbox
        </a>
      )
    }
  },

  render: function() {
    if (
      this.state.conversation &&
      this.state.conversation.messages.length > 0
    ) {
      return (
        <div>
          <div className="link-bar">{this.renderMailboxLink()}</div>
          <Conversation
            conversation={this.state.conversation}
            toggleHandler={() => null}
            addStreamItemHandler={this.addStreamItemHandler}
            archiveHandler={this.archiveHandler}
            unarchiveHandler={this.unarchiveHandler}
            key={this.state.conversation.id}
          />
        </div>
      )
    } else {
      return <div />
    }
  }
})
