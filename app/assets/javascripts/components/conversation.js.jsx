var Conversation = React.createClass({
  renderStatus: function() {
    var isUnread = this.isUnread()
    var isStale = this.isStale()

    if (isUnread || isStale) {
      var classes = window.classNames({
        status: true,
        'status-info': !isStale && isUnread,
        'status-warning': isStale
      })

      return <div className={classes} />
    }
  },

  renderActions: function() {
    var button = null

    if (this.props.conversation.archived) {
      button = (
        <button
          className="btn btn-link btn-xs pull-right"
          onClick={this.props.unarchiveHandler}
        >
          Move to Inbox
        </button>
      )
    }

    return <div className="conversation-actions pull-right">{button}</div>
  },

  renderHeader: function() {
    var title = null
    var preview = null

    if (this.props.conversation.subject) {
      title = this.props.conversation.subject
    } else {
      title = this.props.conversation.summary
    }

    if (this.props.conversation.subject && !this.props.conversation.expanded) {
      preview = (
        <div className="conversation-preview ellipsis-overflow text-muted">
          {this.previewText()}
        </div>
      )
    }

    var subjectClasses = window.classNames({
      'conversation-subject': true,
      'ellipsis-overflow': !this.props.conversation.expanded
    })

    return (
      <div onClick={this.props.toggleHandler}>
        <div className="conversation-header">
          {this.renderStatus()}
          {this.renderActions()}

          <Avatar person={this.props.conversation.creator_person} size="20" />
          <Person person={this.props.conversation.creator_person} />

          <small className="pull-right text-muted padding-top">
            {this.created()}
          </small>

          <div className={subjectClasses}>
            <strong>{title}</strong>
          </div>
          <ConversationTagList tags={this.props.conversation.tags} />

          {preview}
        </div>
      </div>
    )
  },

  renderBody: function() {
    if (this.props.conversation.expanded) {
      return (
        <div className="conversation-body">
          <div className="conversation-stream">
            <Stream
              items={this.streamItems()}
              conversation={this.props.conversation}
              removeTagHandler={this.props.removeTagHandler}
            />
          </div>
          <div className="conversation-response">
            <Response
              conversation={this.props.conversation}
              addStreamItemHandler={this.props.addStreamItemHandler}
              archiveHandler={this.props.archiveHandler}
              demo={this.props.demo}
            />
          </div>
        </div>
      )
    }
  },

  render: function() {
    var classes = window.classNames({
      conversation: true,
      'is-expanded': this.props.conversation.expanded,
      'is-collapsed': !this.props.conversation.expanded
    })

    return (
      <div className={classes}>
        {this.renderHeader()}
        {this.renderBody()}
      </div>
    )
  },

  streamItems: function() {
    var items = _.flatten([
      this.props.conversation.messages,
      this.props.conversation.assignment_events,
      this.props.conversation.tag_events
    ])

    return _.sortBy(items, function(item) {
      return item.created
    })
  },

  // TODO: Implement read receipts
  isUnread: function() {
    return this.props.conversation.unread
  },

  isStale: function() {
    return (
      !this.props.conversation.archived &&
      moment(this.props.conversation.last_activity_at) <
        moment().subtract(3, 'days')
    )
  },

  hasReply: function() {
    return this.props.conversation.messages.length > 1
  },

  previewText: function() {
    var converter = new Showdown.converter()
    return $(
      converter.makeHtml(this.props.conversation.messages[0].content)
    ).text()
  },

  created: function() {
    return moment(this.props.conversation.created).format(CONSTANTS.dateFormat)
  }
})
