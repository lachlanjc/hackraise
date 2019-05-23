const Person = props => (
  <div className="person">
    <span>{props.person.name}</span>
    &nbsp;
    <span className="text-muted">{props.person.email}</span>
  </div>
)
