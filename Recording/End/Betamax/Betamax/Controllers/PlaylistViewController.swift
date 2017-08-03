/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Hero
import UIKit

class PlaylistViewController: UITableViewController {
  
  private static let showVideoSegueIdentifer = "ShowVideo"
  
  private let playlist = VideoStore.shared.playlist
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    return dateFormatter
  }()
  
  private let timeFormatter: DateComponentsFormatter = {
    let timeFormatter = DateComponentsFormatter()
    timeFormatter.allowedUnits = [.minute, .second]
    timeFormatter.unitsStyle = .abbreviated
    return timeFormatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    view.heroModifiers = [.useLayerRenderSnapshot]
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard
      segue.identifier == PlaylistViewController.showVideoSegueIdentifer,
      let destination = segue.destination as? VideoViewController,
      let indexPath = tableView.indexPathForSelectedRow
    else {return}
    
    destination.injectDependencies(
      video: playlist[indexPath.row],
      dateFormatter: dateFormatter,
      timeFormatter: timeFormatter
    )
  }
  
  override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return playlist.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
    cell.injectDependencies(
      video: playlist[indexPath.row],
      dateFormatter: dateFormatter,
      timeFormatter: timeFormatter
    )
    return cell
  }
}
