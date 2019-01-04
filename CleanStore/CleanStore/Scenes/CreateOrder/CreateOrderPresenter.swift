//
//  CreateOrderPresenter.swift
//  CleanStore
//
//  Created by Vo Huy on 1/3/19.
//  Copyright © 2019 Vo Huy. All rights reserved.
//

import UIKit

protocol CreateOrderPresentationLogic
{
  func presentSomething(response: CreateOrder.Something.Response)
}

class CreateOrderPresenter: CreateOrderPresentationLogic
{
  weak var viewController: CreateOrderDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: CreateOrder.Something.Response)
  {
    let viewModel = CreateOrder.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
