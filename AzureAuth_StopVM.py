from azure.identity import AzureCliCredential
from azure.mgmt.resource import SubscriptionClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.compute import ComputeManagementClient
import datetime
import os

LIST_OF_VM = ['c9nl-IssuingCA','c9nl-CA']

#Current Date
now = datetime.datetime.now()

#Get Auth
credential = AzureCliCredential()
subscription_client = SubscriptionClient(credential)
#Get subscritions
subscription = next(subscription_client.subscriptions.list())
subscription_id = subscription.subscription_id

#Get subscriptions
all_subscriptions = [s for s in subscription_client.subscriptions.list()]
naval_subscription_id = (all_subscriptions[0]).subscription_id
smg_subscription_id = (all_subscriptions[1]).subscription_id

# Obtain the management object for resources of Naval.
naval_resource_client = ResourceManagementClient(credential, naval_subscription_id)
naval_compute_client = ComputeManagementClient(credential, naval_subscription_id)
# Obtain the management object for resources of SMG.
smg_resource_client = ResourceManagementClient(credential, smg_subscription_id)
smg_compute_client = ComputeManagementClient(credential, smg_subscription_id)

# Retrieve the list of resource groups for Naval
naval_group_list = naval_resource_client.resource_groups.list()
#List of All resources of subscription
naval_resource_list = naval_resource_client.resources.list()
naval_tags_list = naval_resource_client.tags.list()


# Retrieve the list of resource groups for SMG
#smg_group_list = smg_resource_client.resource_groups.list()
#smg_resource_list = smg_resource_client.resources.list()
#smg_tags_list = smg_resource_client.tags.list()

# Show the groups in formatted output
column_width = 40

try:
    if now.strftime('%A') == 'Wednesday' or now.strftime('%A') == 'Saturday':
        for item_G in naval_group_list:
            dict_of_G = item_G.as_dict()
            naval_compute_list = naval_compute_client.virtual_machines.list(dict_of_G['name'])
            for item_VM in naval_compute_list:
                dict_of_VM = item_VM.as_dict()
                vm = naval_compute_client.virtual_machines.get(dict_of_G['name'], dict_of_VM['name'], expand='InstanceView')
                if 'tags' in dict_of_VM:
                    for i in vm.tags:
                        if vm.tags[i] == 'Weekend' and vm.tags['PowerOff'] == '23:40:00':
                            print(f"{now.today()}:  VM {vm.name} in status: {vm.instance_view.statuses[1].code} with tags: {vm.tags}")
                            if vm.instance_view.statuses[1].code == "PowerState/running":
                                print(f"{now.today()}:  Stop VM: {vm.name} with status: {vm.instance_view.statuses[1].code} and tags RunOn:Weekend")
                                try:
                                    #vm_stop = naval_compute_client.virtual_machines.begin_deallocate(dict_of_G['name'], dict_of_VM['name'])
                                    #vm_stop.wait
                                    print("Try to Stop")
                                except Exception as e:
                                    print(e)
                            elif vm.instance_view.statuses[1].code == "PowerState/deallocated":
                                print(f"{now.today()}:  VM {vm.name} already in stop status: {vm.instance_view.statuses[1].code}. No action required.")
    else:
        print(f"Today is {now.today().strftime('%A')}. It is not a weekend.")
except Exception as e:
    print(e)
print(column_width*'-')

