$(function() {
  var conversationList = ConversationList({ demo: true, conversations: [] })

  // TODO: This is so terrible. Wrap everything up in a React component to avoid this
  function updateConversationList(conversation) {
    var conversations = conversationList.state.conversations.concat(
      conversation
    )
    conversationList.setState({ conversations: conversations })
  }

  function sendFromEmail() {
    if (!validateEmail()) {
      return
    }

    var email = $('[name="email[from]"]').val()

    var author = {
      email: email,
      gravatar_url: gravatarUrl(email)
    }

    var conversation = {
      author: author,
      subject: $('[name="email[subject]"]').val(),
      body: $('[name="email[body]"]').val()
    }

    addConversation(conversation)

    clearEmail()
  }

  function validateEmail() {
    var $subject = $('[name="email[subject]"]')
    var $body = $('[name="email[body]"]')
    var valid = true

    if ($subject.val()) {
      $subject.closest('.form-group').removeClass('has-error')
    } else {
      $subject.closest('.form-group').addClass('has-error')
      valid = false
    }

    if ($body.val()) {
      $body.closest('.form-group').removeClass('has-error')
    } else {
      $body.closest('.form-group').addClass('has-error')
      valid = false
    }

    return valid
  }

  function clearEmail() {
    $('[name="email[subject]"]').val('')
    $('[name="email[body]"]').val('')
  }

  function addConversation(attributes) {
    var conversation = {
      id: 'conversation-' + new Date().getTime(),
      archived: false,
      subject: attributes.subject,
      creator_person: attributes.author,
      messages: [
        {
          id: 'message-' + new Date().getTime(),
          content: attributes.body,
          type: 'message',
          person: attributes.author
        }
      ],
      assignment_events: [],
      tag_events: []
    }

    updateConversationList(conversation)
  }

  function gravatarUrl(email) {
    var digest = md5(email)
    return (
      'https://secure.gravatar.com/avatar/' +
      digest +
      '?d=identicon&size=40.png'
    )
  }

  React.renderComponent(conversationList, $('.react')[0])

  $('.email-send').click(function(e) {
    e.preventDefault()
    sendFromEmail()
  })
})
