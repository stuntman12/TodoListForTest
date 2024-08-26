//
//  ViewController.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

//MARK: - Protocol View
protocol ITodoListView {
    func render(items: [Todo])
    func openAlertCreateTask()
    func editTask(indexPatch: Int)
    func renderAlertError(text: String)
}

final class TodoListView: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind,Todo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionKind, Todo>
    
    //MARK: Section kind
    enum SectionKind {
        case task
    }
    
    private lazy var collectionView: UICollectionView = createCollectionView()
    private var dataSource: DataSource!
    
    private var items: [Todo] = []
    
    //MARK: - Dependencies
    private var router: IRouter?
    var interactor: ITodoListInteractor?
    
    //MARK: Init
    init(router: IRouter) {
        super.init(nibName: nil, bundle: nil)
        self.router = router
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        settingController()
    }
    
    //MARK: objct func
    @objc func createTask() {
        self.interactor?.addTask()
    }
    
    @objc func update() {
        self.interactor?.fetchData()
    }
    
    @objc func deleteAll() {
        self.interactor?.deleteAll()
    }
}

//MARK: - IToDoListView
extension TodoListView: ITodoListView {
    func render(items: [Todo]) {
        self.items = items
        self.createSnapshot()
    }
    
    func openAlertCreateTask() {
        showAlertCreateTask()
    }
    
    func editTask(indexPatch: Int) {
        self.showEditAlert(indexPatch: indexPatch)
    }
    
    func renderAlertError(text: String) {
        self.router?.showAlertErrorLoad(text: text)
    }
}

//MARK: - UICollectionViewDelegate
extension TodoListView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.interactor?.editTask(indexPatch: indexPath.row)
    }
}

//MARK: - Setting Controller
private extension TodoListView {
    func settingController() {
        view.backgroundColor = .white
        settingNavigation()
        createDataSource()
        interactor?.fetchData()
    }
        
    func settingNavigation() {
        title = "ToDoList"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addToDoList = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(createTask)
        )
        
        let updateToDoList = UIBarButtonItem(
            image: UIImage(systemName: "goforward"),
            style: .done,
            target: self,
            action: #selector(update)
        )
        
        let deleteButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(deleteAll)
        )
        
        navigationItem.leftBarButtonItem = updateToDoList
        navigationItem.rightBarButtonItems = [addToDoList, deleteButton]
    }
}

//MARK: - Setting CollectionView
private extension TodoListView {
    
    func createCollectionView() -> UICollectionView {
        let collection = UICollectionView(
            frame: view.safeAreaLayoutGuide.layoutFrame,
            collectionViewLayout: createCollectionLayout()
        )
        collection.backgroundColor = .white
        collection.delegate = self
        view.addSubview(collection)
        return collection
    }
    
    func createCollectionLayout() -> UICollectionViewLayout {
        
        let widthItem: CGFloat = 1
        let heightItem: CGFloat = 1
        
        let widthGroup: CGFloat = 1
        let heightGroup: CGFloat = 0.1
        
        let layoutConfiguration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            index,
            envirment in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(widthItem),
                    heightDimension: .fractionalHeight(heightItem)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(widthGroup),
                    heightDimension: .fractionalHeight(heightGroup)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }, configuration: layoutConfiguration)
        
        return layout
    }
    
    func createDataSource() {
        let cell = UICollectionView.CellRegistration<TodoListCell, Todo> {
            cell,
            indexPath,
            itemIdentifier in
            
            cell.config(
                descr: itemIdentifier.todo,
                title: itemIdentifier.id.description,
                status: itemIdentifier.completed
            )
        }
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: {
                collectionView,
                indexPath,
                itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cell,
                    for: indexPath,
                    item: itemIdentifier
                )
            }
        )
        
        createSnapshot()
    }
    
    func createSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.task])
        snapshot.appendItems(self.items, toSection: .task)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - Alert
private extension TodoListView {
    func showAlertCreateTask() {
        let alert = UIAlertController(title: "Создать", message: "Напишите то что нужно сделать", preferredStyle: .alert)
        
        let saveButton = UIAlertAction(
            title: "Сохранить",
            style: .default) { [weak self] _ in
                let id = Int.random(in: 1...1000)
                guard let textField = alert.textFields?[0] else { return }
                self?.interactor?.saveTask(id: id, body: textField.text ?? "Добавьте задачу")
            }
        
        alert.addAction(saveButton)
        
        alert.addTextField { textField in
            textField.placeholder = "Что нужно сделать?"
        }
        
        
        present(alert, animated: true)
    }
    
    func showEditAlert(indexPatch: Int) {
        let alert = UIAlertController(
            title: "Изменить",
            message: "Измените текст или готовность задачи",
            preferredStyle: .alert
        )
        let taskForIndexPatch = self.items[indexPatch]
        
        let editButton = UIAlertAction(title: "Изменить", style: .default) { [weak self] textField in
            guard let TaskBodyTextField = alert.textFields?.first?.text else { return }
            self?.interactor?.updateTask(item: taskForIndexPatch, body: TaskBodyTextField, completed: taskForIndexPatch.completed)
            self?.interactor?.fetchData()
        }
        
        let completedButton = UIAlertAction(
            title: taskForIndexPatch.completed ? "Не выполнена?" : "Выполнена?",
            style: .default) { [weak self] _ in
                guard let TaskBodyTextField = alert.textFields?.first?.text else { return }
                let toggle = taskForIndexPatch.completed  ? false : true
                self?.interactor?.updateTask(item: taskForIndexPatch, body: TaskBodyTextField, completed: toggle)
        }
        
        let deleteButton = UIAlertAction(
            title: "Удалить",
            style: .destructive) { [weak self] _ in
                self?.interactor?.deleteItem(id: taskForIndexPatch.id)
            }
        
        alert.addAction(deleteButton)
        alert.addAction(editButton)
        alert.addAction(completedButton)
        alert.addTextField { [weak self] in
            $0.text = self?.items[indexPatch].todo
        }
        present(alert, animated: true)
    }

}
