import $ from 'jquery'

const CSRF = {
  token: function() {
    return $('meta[name="csrf-token"]').attr('content')
  }
}

export default CSRF
