const TagEvent = props => (
  <div className="event">
    <div className="pull-right">{timestamp(props.created)}</div>
    <Avatar person={props.user.person} size="20" />
    <strong children={props.user.person.name} />
    &nbsp;tagged this with&nbsp;
    <a href="#" className="label label-default">
      #{props.tag}
      <span
        onClick={props.removeTagHandler(props)}
        className="geomicon geomicon-delete"
      />
    </a>
  </div>
)
