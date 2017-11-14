import React from 'react'

import Api from 'api'
import { durationOfTimeInWords } from 'utils'

import LongDate from './LongDate'
import RideMap from './RideMap'

import 'stylesheets/rides.scss'

export default class Ride extends React.Component {
  state = {
    loading: true,
    ride: {},
    error: null
  }

  componentWillMount() {
    const { id } = this.props
    Api.getRide(id).then(
      (ride) => this.setState({ ride, loading: false }),
      (error) => this.setState({ error, loading: false })
    )
  }

  render() {
    const { loading, ride } = this.state
    if (loading) {
      return <p>Loading...</p>
    }

    return (
      <div className="ride">
        <h1>{ride.trail.name} on <LongDate date={ride.start_time} /></h1>
        <table className="table">
          <tbody>
          <tr>
            <th>Distance</th>
            <td>{ride.distance.toFixed(2)} miles</td>
          </tr>
          <tr>
            <th>Time Riding</th>
            <td>{durationOfTimeInWords(ride.moving_duration)}</td>
          </tr>
          <tr>
            <th>Time Stopped</th>
            <td>{durationOfTimeInWords(ride.duration - ride.moving_duration)}</td>
          </tr>
          <tr>
            <th>Average Speed</th>
            <td>{ride.avg_speed.toFixed(2)} mph</td>
          </tr>
          </tbody>
        </table>
        <RideMap ride={ride} />
      </div>
    )
  }
}
