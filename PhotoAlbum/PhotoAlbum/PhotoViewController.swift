import UIKit
import  MobileCoreServices



class PhotoViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    // MARK: - Model
    
    enum ImageSource {
        case remote(URL, UIImage)
        case local(Data, UIImage)
        
        // convenience method since both cases have the UIImage
        var image: UIImage {
            switch self {
            case .remote(_, let image): return image
            case .local(_, let image): return image
            }
        }
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        if let image=photoView.snapshot
        {
            let avc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            avc.popoverPresentationController?.sourceView=self.view
            
            self.present(avc, animated: true, completion: nil)
        }
    }
    
    var photo: Photo? {
        get  {
            // all we have to do here is call the proper init() in EmojiArt
            if let imageSource = backgroundImage {
                let emojis = photoView.subviews.compactMap { $0 as? UILabel }.compactMap { Photo.Emoji(label: $0) }
                switch imageSource {
                case .remote(let url, _): return Photo(url: url, info: emojis)
                case .local(let imageData, _): return Photo(imageData: imageData, info: emojis)
                }
            }
            return nil
        }
        set{
            backgroundImage = nil
            photoView.subviews.compactMap { $0 as? UILabel }.forEach { $0.removeFromSuperview() }
           
            let imageData = newValue?.imageData
            let image = (imageData != nil) ? UIImage(data: imageData!) : nil
            // see if the newValue EmojiArt has a url
            if let url = newValue?.url {
              
                imageFetcher = ImageFetcher() { (url, image) in
                    DispatchQueue.main.async {
                       
                        if image == self.imageFetcher.backup {
                            self.backgroundImage = .local(imageData!, image)
                        } else {
                            self.backgroundImage = .remote(url, image)
                        }
                        
                        newValue?.info.forEach {
                            let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            self.photoView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
                imageFetcher.backup = image
                imageFetcher.fetch(url)
            } else if image != nil {
               
                backgroundImage = .local(imageData!, image!)
               
                newValue?.info.forEach {
                    let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                    self.photoView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = ((info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage)?.scaled(by: 0.25) {
            //            let url = image.storeLocallyAsJPEG(named: String(Date.timeIntervalSinceReferenceDate))
            if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                backgroundImage = .local(imageData, image)
                documentChanged()
            }
        }
        picker.presentingViewController?.dismiss(animated: true)
        
    }
    var document: PhotoDocument?
    
    func documentChanged() {
        document?.photo = photo
        if document?.photo != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem? = nil) {
        document?.photo = photo
        if  document?.photo != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    @IBAction func close(_ sender: UIBarButtonItem? = nil) {
        
        if document?.photo != nil {
            document?.thumbnail = photoView.snapshot
        }
        if let observer = self.photoViewObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        presentingViewController?.dismiss(animated: true) {
            
            self.document?.close()
            }
    }
    
    private var photoViewObserver: NSObjectProtocol?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if document?.documentState != .normal {
         
            document?.open { success in
                if success {
                    self.title = self.document?.localizedName
                    self.photo = self.document?.photo
                    self.photoViewObserver = NotificationCenter.default.addObserver(
                        forName: .photoViewDidChange,
                        object: self.photoView,
                        queue: OperationQueue.main,
                        using: { notification in
                            self.documentChanged()
                    })
                }
            }
        }
    }
    
    // MARK: - Storyboard

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(photoView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    
    private var _backgroundImageURL: URL?
    
    var backgroundImage: ImageSource? {
        didSet {
            scrollView?.zoomScale = 1.0
            photoView.backgroundImage = backgroundImage?.image
            let size = backgroundImage?.image.size ?? CGSize.zero
            photoView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
    var photoView = PhotoView()
    
    // MARK: - Emoji Collection View

    var emojis = "😀🎁✈️🎱🍎🐶🐝☕️🎼🚲♣️👨‍🎓✏️🌈🤡🎓👻☎️".map { String($0) }

    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
            emojiCollectionView.dragInteractionEnabled = true
        }
    }
    
    private var font: UIFont {
       
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64.0))
        
    }
    
    private var addingEmoji = false
    
    @IBAction func addEmoji() {
        addingEmoji = true
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return emojis.count
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "EmojiCell", for: indexPath)
            if let emojiCell = cell as? EmojiCollectionViewCell {
                let text = NSAttributedString(string: emojis[indexPath.item],
                                          attributes: [.font:font])
                emojiCell.label.attributedText = text
            }
            return cell
        } else if addingEmoji {
            let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "EmojiInputCell", for: indexPath)
            if let inputCell=cell as? TextFieldCollectionViewCell
            {
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    
                    if let text=inputCell.textField.text
                    {
                        self?.emojis=(text.map {String($0)} + self!.emojis).uniquified
                    }
                    self?.addingEmoji = false
                    
                    self?.emojiCollectionView.reloadData()
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "AddEmojiButtonCell", for: indexPath)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
        ) {
        if let inputCell = cell as? TextFieldCollectionViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }

    // MARK: - UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if !addingEmoji,
            let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as?
                                       EmojiCollectionViewCell)?.label.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        } else {
            return []
        }
    }

    // MARK: - UICollectionViewDropDelegate

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
        ) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1 {
            let isSelf =
                (session.localDragSession?.localContext as? UICollectionView) ==
                                                                     collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy,
                                                intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    collectionView.performBatchUpdates({
                        emojis.remove(at: sourceIndexPath.item)
                        emojis.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell")
                )
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojis.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }

    @IBOutlet weak var cameraButton: UIBarButtonItem!
        {
        didSet{
             cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }
    
    @IBAction func takeBackgroundPhoto(_ sender: UIBarButtonItem) {
        let picker  = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes=[kUTTypeImage as String]
        picker.allowsEditing=true
        picker.delegate=self
        present(picker,animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - UIDropInteractionDelegate

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                if image == self.imageFetcher.backup {
                   
                    if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                        self.backgroundImage = .local(imageData, image)
                        self.documentChanged()
                    } else {
                      
                        self.presentBadURLWarning(for: url)
                    }
                } else {
                 
                    self.backgroundImage = .remote(url, image)
                    self.documentChanged()
                }
            }
        }
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
                
                if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                    self.backgroundImage = .local(imageData, image)
                    self.documentChanged()
                }
            }
        }
      
    }
    // MARK: - Bad URL Warnings
    
    private func presentBadURLWarning(for url: URL?) {
        if !suppressBadURLWarnings {
            let alert = UIAlertController(
                title: "Image Transfer Failed",
                message: "Couldn't transfer the dropped image from its source.\nShow this warning in the future?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Keep Warning",
                style: .default
            ))
            alert.addAction(UIAlertAction(
                title: "Stop Warning",
                style: .destructive,
                handler: { action in
                    self.suppressBadURLWarnings = true
            }
            ))
            present(alert, animated: true)
        }
    }
    
    private var suppressBadURLWarnings = false
}

