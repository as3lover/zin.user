//
//  LanguageDictionary.swift
//  zin
//
//  Created by Morteza on 6/29/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation

class LanguageDictionary{
    
    private static var all:[Language:[String:String]] = [.Arabic : [:], .English:[:], .Persian:[:], .Turkish:[:]]
    
    public static func start()
    {
        languageToDic(.Arabic)
        languageToDic(.English)
        languageToDic(.Persian)
        languageToDic(.Turkish)
    }
    
    private static func languageToDic(_ lang:Language)
    {
        var string :String?
        
        if let filepath = Bundle.main.path(forResource: lang.rawValue, ofType: "xml") {
            do {
                let contents = try String(contentsOfFile: filepath)
                //print(contents)
                string = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        if let string = string
        {
            var xml = try! XML.parse(string)
            xml = xml["resources"]["string"]
            for element in xml {
                if let key = element.attributes["name"]
                {
                    add(key, element.text ?? "", lang)
                }
                //print(element.attributes["name"] ?? "No att" ,element.text ?? "no data")
            }
        }
    }
    
    static func add(_ key:String, _ val:String, _ lang:Language)
    {
        all[lang]?[key] = val
    }
    
    
    static func getString(_ key:LanguagrDic)->String!
    {
        return (all[Constants.language]?[key.rawValue]) ?? ""
    }
    
}

class Lang{
    static var Set = LanguageDictionary.add
    static var Get = LanguageDictionary.getString
    static var start = LanguageDictionary.start
}

extension String
{
    static func transLae(_ key: LanguagrDic)->String
    {
        return LanguageDictionary.getString(key) ?? ""
    }
}

import UIKit
extension UIViewController
{
    static var Get = LanguageDictionary.getString
}



enum LanguagrDic:String{
    case signup_fullname_edt
    case valid_sms_edt
    case valid_sms_submit
    case loading_sms_title
    case loading_sms_login
    case error_in_progress
    case enter_phone_number
    case enter_name
    case failure_general
    case app_name
    case title_activity_maps
    case input_app_phonenumber
    case title_app_password
    case title_app_signin
    case navigation_drawer_open
    case navigation_drawer_close
    case request_service
    case nav_profile
    case showtrips
    case messages
    case credits
    case setting
    case support
    case remaining_credits
    case increase_credits
    case select_language
    case enable_location_desc
    case enabl_location_title
    case enable_location_submit
    case cancel
    case title_app_signup
    case title_app_signup_easy
    case signup_name_edt
    case signup_lastname_edt
    case sms_not_recieved
    case forget_password
    case input_start_point
    case enter_password
    case input_end_point
    case submit_starting_point
    case submit_ending_point
    case service_type_lable
    case request_password
    case valid_identity
    case enter_validity_code
    case enter_new_password
    case submit_account
    case service_attr_lable
    case service_vehicle_lable
    case start_point_txt
    case time_lable
    case distance_lable
    case price_lable
    case how_much_charge
    case choose_start_point
    case submit_trip
    case success_wait_for_call
    case choose_end_point
    case submit_changes
    case subscribe_email
    case subscribe_messages
    case pride
    case peogeot405
    case peogeotrd
    case peogeotpars
    case zantia
    case rio
    case tiba
    case kia
    case hyundai
    case benz
    case bmw
    case hues
    case van
    case minibus
    case normal
    case lux
    case child
    case womans
    case cooler
    case sound_system
    case video_system
    case sport
    case exit_message
    case enter_valid_date
    case no_internet_connection
    case trips_header
    case fav_trips
    case unnamed_road
    case do_you_want_to_signout
    case yes
    case no
    case agency_name
    case agency_address
    case agency_tel
    case ServerError
    case peogeot206
    case trip
    case unnamed_road4
    case Error
    case DbValidationError
    case InvalidUserId
    case InvalidUserModel
    case InvalidUserPassword
    case InvalidUserMobile
    case DeviceIdIsRegistere
    case CanNotDeleteAddress
    case AddressYouDoNotOwn
    case CityNameWrong
    case StateNameWrong
    case CountryNameWrong
    case AddressNoNotBeNull
    case PostalCodeCannotBeNull
    case PostalCodeMustBe10Digits
    case CategoryIsActive
    case CategoryIsDeActive
    case InvalidSupportId
    case SupportTicketIdStatusIsClose
    case InvalidOrderId
    case OrderIsNotOwnedByUser
    case NotEnoughItem
    case NotEnoughMoney
    case WalletAllReadyCharge
    case gender_male
    case gender_famele
    case fetching_location
    case is_service_good
    case send
    case rating
    case wait_for_sms
    case welcome_to_zin
    case no_service_availible
    case service_system_has_problem
    case error_in_signup
    case tomans
    case estimate_price
    case enter_your_pin
    case cancel_service
    case active_services
    case use_pin_input
    case input_your_first_code
    case pins_not_equal
    case do_not_use_pin
    case cash
    case choose_number_ofservices
    case no_active_service
    case fav_pos_saved
    case enter_location_lable
    case title
    case submit
    case input_your_second_code
    case wallet
    case how_to_pay
    case online
    case edit_Profile_done
    case hello
    case persian
    case english
    case turkish
    case zin_services
    case this_service_is_not_avalible
    case backup_tel
    case arabic
    case driver_name
    case car_model
    case car_number
    case version
    case number_of_services
}
