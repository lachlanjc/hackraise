var Stream = React.createClass({
  renderStreamItem: function(item) {
    var ComponentClass = this.componentForType(item.type)
    var attributes = item

    if (item.type == 'tagevent') {
      attributes.removeTagHandler = this.props.removeTagHandler
    }

    return (
      <div className="stream-item" key={item.id}>
        <ComponentClass {...attributes} />
      </div>
    )
  },

  render: function() {
    var streamItems = this.props.items.map(this.renderStreamItem)

    return <div className="stream">{streamItems}</div>
  },

  componentForType: function(type) {
    return {
      message: Message,
      assignmentevent: AssignmentEvent,
      tagevent: TagEvent
    }[type]
  }
})
