const content = body => {
  const converter = new Showdown.converter()
  return converter.makeHtml(body)
}

const Message = props => (
  <div className="message">
    <div className="message-header">
      <span className="pull-right text-muted">{timestamp(props.created)}</span>
      <Avatar person={props.person} size="20" />
      <Person person={props.person} />
    </div>
    <div
      className="message-content"
      dangerouslySetInnerHTML={{ __html: content(props.content) }}
    />
  </div>
)
