//
//  ExchangeRateHistoryViewController.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import UIKit

class ExchangeRateHistoryViewController : BaseViewController {
    
    @IBOutlet weak var tblHistory: UITableView!
    
    var rateViewModel : ExchangeRateViewModel = ExchangeRateViewModel()
    var selectedCurrencyType : CurrencyType?
    var currencyTypeList : [CurrencyType] = [.usd , .gbp , .eur]
    var saveExchageRateList : [SaveExchangeRateVO] = []
    var serverTimeList : [SaveServerTimeVO] = []
    var totalcount = 0
    var selectedStartDate = Date()
    var selectedEndDate = Date()
    var selectedStartTime = Date()
    var selectedEndTime = Date()
    var maxDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    var minDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
    var selectedTime = Date()
    var maxTime = Calendar.current.date(byAdding: .hour, value: 12, to: Date())
    var minTime = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
    var startDate : String = ""
    var dataList : [[String : [SaveExchangeRateVO]]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rateViewModel.selectedEndDateCurrentValueSubject.send(maxDate?.getFormattedDateString(formatString: "dd/MM/yyyy") ?? "")
        rateViewModel.selectedStartDateCurrentValueSubject.send(minDate?.getFormattedDateString(formatString: "dd/MM/yyyy") ?? "")
        rateViewModel.selectedStartTimeCurrentValueSubject.send(maxDate?.getFormattedDateString(formatString: "h : mm a") ?? "")
        rateViewModel.selectedEndTimeCurrentValueSubject.send(minDate?.getFormattedDateString(formatString: "h : mm a") ?? "")
        fetchData()
    }
    
    func calculateCellCount() {
        let grouped = saveExchageRateList.group(by: \.saveServerTimeId)
        grouped.forEach { (key, value) in
            serverTimeList.forEach { data in
                if data.id == key {
                    totalcount = totalcount + 1
                    dataList.append([data.lastUpdateTime ?? "" : value])
                }
            }
        }
        tblHistory.reloadData()
    }
    func fetchData() {
        dataList.removeAll()
        serverTimeList.removeAll()
        saveExchageRateList.removeAll()
        var startDateAndTime = ""
        if let dateAndTime = XTDateFormatterStruct.xt_dayUploadFormatter().date(from: rateViewModel.selectedStartDateCurrentValueSubject.value + " " +
                                                                                      rateViewModel.selectedStartTimeCurrentValueSubject.value)
        {
            startDateAndTime = " \(XTDateFormatterStruct.xt_fullLongDateFormatter().string(from: dateAndTime))"
        }
        var endDateAndTime = ""
        if let dateAndTime = XTDateFormatterStruct.xt_dayUploadFormatter().date(from: rateViewModel.selectedEndDateCurrentValueSubject.value + " " +
                                                                                      rateViewModel.selectedEndTimeCurrentValueSubject.value)
        {
            endDateAndTime = " \(XTDateFormatterStruct.xt_fullLongDateFormatter().string(from: dateAndTime))"
        }
        if startDateAndTime == endDateAndTime {
            rateViewModel.retrieveSaveServerTimeByDate(date: startDateAndTime)
        } else {
            Dates.printDatesBetweenInterval(Dates.dateFromString(startDateAndTime), Dates.dateFromString(endDateAndTime)).forEach { ddate in
                rateViewModel.retrieveSaveServerTimeByDate(date: ddate.getFormattedDateString(formatString: "YYYY-MM-dd'T'HH:mm:ss") )
            }
        }
        rateViewModel.retrieveAllExchangeRate()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationTitle(title: "History")
        addBackButton()
        setupTableView()
    }
    
    override func setupLanguage() {
        super.setupLanguage()
    }
    
    override func didTapBackBtn() {
        AppScreens.shared.goBackToHomeVC()
    }
    
    func setupTableView() {
        tblHistory.delegate = self
        tblHistory.dataSource = self
        tblHistory.showsVerticalScrollIndicator = false
        tblHistory.contentInsetAdjustmentBehavior = .never
        tblHistory.separatorStyle = .none
        tblHistory.registerForCells(cells: [
            TimeItemTableViewCell.self,
            ItemTableViewCell.self,
            DateItemTableViewCell.self,
            ChooseCurrencyItemTableViewCell.self,
            EmptyTableViewCell.self])
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        rateViewModel.bindViewModel(in : self)
    }
    
    override func bindData() {
        super.bindData()
        
        rateViewModel.selectedStartDateCurrentValueSubject.sink{ [unowned self] in
            selectedStartDate = $0.convertStringToDate(format: "dd/MM/yyyy")
            fetchData()
            self.tblHistory.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 3, section: 0)], with: .none)
        }.store(in: &bindings)
        
        rateViewModel.selectedEndDateCurrentValueSubject.sink{ [unowned self] in
            selectedEndDate = $0.convertStringToDate(format: "dd/MM/yyyy")
            fetchData()
            self.tblHistory.reloadRows(at: [IndexPath(row: 0, section: 0),IndexPath(row: 3, section: 0)], with: .none)
        }.store(in: &bindings)
        
        rateViewModel.selectedStartTimeCurrentValueSubject.sink{ [unowned self] in
            selectedStartTime = $0.convertStringToDate(format: "h : mm a")
            self.tblHistory.reloadRows(at: [IndexPath(row: 1, section: 0),IndexPath(row: 3, section: 0)], with: .none)
        }.store(in: &bindings)
        
        rateViewModel.selectedEndDateCurrentValueSubject.sink{ [unowned self] in
            selectedEndTime = $0.convertStringToDate(format: "h : mm a")
            self.tblHistory.reloadRows(at: [IndexPath(row: 1, section: 0),IndexPath(row: 3, section: 0)], with: .none)
        }.store(in: &bindings)
        
        rateViewModel.selectedCurrrencyTypePublishSubject.sink{ [unowned self] in
            self.selectedCurrencyType = $0
            fetchData()
            self.tblHistory.reloadRows(at: [IndexPath(row: 2, section: 0),IndexPath(row: 3, section: 0)], with: .none)
        }.store(in: &bindings)
        
        rateViewModel.exchangeRatePublishSubject.sink{ [unowned self] in
            if !$0.isEmpty{
                self.saveExchageRateList = $0
            }
            calculateCellCount()
        }.store(in: &bindings)
        
        rateViewModel.saveServerTimeListByDatePublishSubject.sink{ [unowned self] in
            if !$0.isEmpty{
                self.serverTimeList = $0
            }
        }.store(in: &bindings)
    }
    
    private func showCurrencyPicker() {
        let idx = self.currencyTypeList.firstIndex(where: {$0.getID() == selectedCurrencyType?.getID()})
        let nameArray = self.currencyTypeList.compactMap {
            return "\($0.getCurrencyName()) - \($0.getDescription())"
        }
        CustomPicker.selectOption(title: "Choose Currency", cancelText: "Cancel", dataArray: nameArray, selectedIndex: idx) {[weak self] (selctedText, atIndex) in
            self?.rateViewModel.selectedCurrrencyTypePublishSubject.send(self?.currencyTypeList[atIndex] ?? .usd)
        }
    }
    
    private func showDatePicker(type: DateType){
        switch type {
        case .start_date:
            CustomPicker.selectDate(title: "Select Start Date",cancelText: "Cancel", datePickerMode: .date,selectedDate : selectedStartDate,minDate: nil, maxDate: selectedEndDate, didSelectDate: { [weak self](date) in
               self?.selectedStartDate = date
                self?.rateViewModel.selectedStartDateCurrentValueSubject.send(self?.selectedStartDate.getFormattedDateString(formatString: "dd/MM/yyyy") ?? "")
            })
        case .end_date:
            CustomPicker.selectDate(title: "Select End Date", cancelText: "Cancel", datePickerMode: .date,selectedDate : selectedEndDate, minDate: selectedStartDate, maxDate: Date(), didSelectDate: {[weak self] (date) in
                self?.selectedEndDate = date
                self?.rateViewModel.selectedEndDateCurrentValueSubject.send(self?.selectedEndDate.getFormattedDateString(formatString: "dd/MM/yyyy") ?? "")
            })
        }
    }
    
    private func showTimePicker(type: TimeType){
        switch type {
        case .start_time:
            CustomPicker.selectDate(title: "Select Start Time", cancelText: "Cancel", datePickerMode: .time,selectedDate : selectedStartTime,minDate: minTime, maxDate: maxTime, didSelectDate: { [weak self](date) in
                self?.rateViewModel.selectedStartTimeCurrentValueSubject.send(date.getFormattedDateString(formatString: "hh:mm a"))
            })
        case .end_time:
            CustomPicker.selectDate(title: "Select End Time", cancelText: "Cancel", datePickerMode: .time,selectedDate : selectedEndTime, minDate: minTime, maxDate: maxTime, didSelectDate: {[weak self] (date) in
                self?.rateViewModel.selectedEndTimeCurrentValueSubject.send(date.getFormattedDateString(formatString: "hh:mm a"))
            })
        }
    }
}

extension ExchangeRateHistoryViewController : TableViewDelegateAndDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalcount + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            return getTimeItemCell(indexPath: indexPath)
        case 1:
            return getDateItemCell(indexPath: indexPath)
        case 2 :
            return getCurrencyItemCell(indexPath: indexPath)
        default:
            return getItemTableViewCell(indexPath: indexPath)
        }
    }
}

extension ExchangeRateHistoryViewController {
    func getDateItemCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHistory.dequeReuseCell(type: DateItemTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupCell(viewModel: &rateViewModel)
        return cell
    }
    
    func getEmptyTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHistory.dequeReuseCell(type: EmptyTableViewCell.self, indexPath: indexPath)
        return cell
    }
    
    func getCurrencyItemCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHistory.dequeReuseCell(type: ChooseCurrencyItemTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupCell(viewModel: &rateViewModel)
        return cell
    }
    
    func getTimeItemCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHistory.dequeReuseCell(type: TimeItemTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupCell(viewModel: &rateViewModel)
        return cell
    }
    
    func getItemTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHistory.dequeReuseCell(type: ItemTableViewCell.self, indexPath: indexPath)
        cell.setupCell(data: dataList[indexPath.row - 3])
        return cell
    }
}

extension ExchangeRateHistoryViewController : ChooseCurrencyItemTableViewCellDelegate {
    func didChooseCurrency() {
        self.showCurrencyPicker()
    }
}

extension ExchangeRateHistoryViewController : DateItemTableViewCellDelegate {
    func didTapDate(type: DateType) {
        self.showDatePicker(type: type)
    }
}

extension ExchangeRateHistoryViewController : TimeItemTableViewCellDelegate {
    func didTapTime(type: TimeType) {
        self.showTimePicker(type: type)
    }
}
