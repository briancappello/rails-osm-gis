import React from 'react'
import ReactDOM from 'react-dom'
import { getUrlParams } from 'utils'

import Ride from 'components/Ride'

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Ride id={getUrlParams('/rides/:id').id} />,
    document.getElementById('app'),
  )
})
