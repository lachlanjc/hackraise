const getComponentForType = type =>
  ({
    message: Message,
    assignmentevent: AssignmentEvent,
    tagevent: TagEvent
  }[type])

const StreamItem = props => {
  const ComponentClass = getComponentForType(props.item.type)
  const attrs = props.item

  if (props.item.type == 'tagevent') {
    attrs.removeTagHandler = props.removeTagHandler
  }

  return (
    <div className="stream-item">
      <ComponentClass {...attrs} />
    </div>
  )
}

const Stream = props => (
  <div className="stream">
    {props.items.map(item => (
      <StreamItem
        removeTagHandler={props.removeTagHandler}
        item={item}
        key={item.id}
      />
    ))}
  </div>
)
