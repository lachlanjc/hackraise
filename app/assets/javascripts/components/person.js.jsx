var Person = React.createClass({
  render: function() {
    return (
      <div className="person">
        <span>{this.props.person.name}</span>
        &nbsp;
        <span className="text-muted">{this.props.person.email}</span>
      </div>
    )
  }
})
