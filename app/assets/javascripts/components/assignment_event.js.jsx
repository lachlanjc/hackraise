const timestamp = dt => moment(dt).format(CONSTANTS.dateFormat)

const AssignmentEvent = props => (
  <div className="event">
    <div className="pull-right text-muted">{timestamp(props.created)}</div>
    <Avatar person={props.user.person} size="20" />
    <strong children={props.user.person.name} />
    &nbsp;assigned this to&nbsp;
    <Avatar person={props.assignee.person} size="20" />
    <strong children={props.user.person.name} />
  </div>
)
